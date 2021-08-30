//
//  CollectionViewDiffableDelegatingDataSource.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 10.03.2021.
//

import UIKit

/**
 Automatically remembers (stores) the content displayed by the collection view cell.
 When any new snapshot is applied using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
 then items requiring reload are automaticaly identified, and are added to the snapshot being applied.
 */
open class CollectionViewDiffableDelegatingDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType,
    Delegate: ReloadingDataSourceDelegate,
    EquatableCellContent: Equatable
>: CollectionViewDiffableReloadingDataSource<SectionIdentifierType, ItemIdentifierType, EquatableCellContent>
where Delegate.ItemIdentifierType == ItemIdentifierType {
    
    public typealias CellContentProvider = (ItemIdentifierType) -> EquatableCellContent?
    public typealias CellWithContentProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> (cell: UICollectionViewCell?, cellContent: EquatableCellContent?)
    
    /// Delegate allows implementation of any locking mechanism before/after item is read
    public weak var delegate: Delegate?
    
    /**
     Automatically remembers (stores) the content displayed by the collection view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`
     always reloads such an item identifier (collection view cell).
     
     If delegate is set, __you have to call the delegate methods__ in `cellWithContentProvider` before and after you access the underlying data!
     
     Pros:
     - optimized for performance
     - the code in `cellContentProvider` very likely gets an item data per given item identifier. Such a item data is used for configuring the collection view cell,
     and can be also used for computing the `EquatableCellContent`. So, it is optimal to return not only the cell, but also the `EquatableCellContent`
     together in a tuple.
     
     Cons:
     - adds a bit of complexity
     - the return type varies from the original UIKit return value
     - it may be difficult to avoid code duplication, as the `EquatableCellContent` has to be returned both in `cellWithContentProvider`
     and `cellContentProvider` parameters.
     
     - Parameters:
        - collectionView: collection view used with this diffable data source
        - cellContentProvider: returns `EquatableCellContent?`. `EquatableCellContent?` represents the (visible) content of the cell and is used for resolving,
     whether the cell needs reload or not when new snapshot is being applied. The delegate methods are called automatically before and after this closure is executed.
        - cellWithContentProvider: returns a tuple `(UICollectionViewCell?, EquatableCellContent?)`.  `UICollectionViewCell` is
     the configured cell, `EquatableCellContent?` represents the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     When delegate is set, do not forget to call the delegate methods before and after you access the underlying data.
     */
    public override init(
        collectionView: UICollectionView,
        cellContentProvider: @escaping CellContentProvider,
        cellWithContentProvider: @escaping CellWithContentProvider
    ) {
        super.init(
            collectionView: collectionView,
            cellContentProvider: cellContentProvider,
            cellWithContentProvider: cellWithContentProvider
        )
    }
    
    /**
     Automatically remembers (stores) the content displayed by the collection view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`
     always reloads such an item identifier (collection view cell).
     
     If delegate is set, __you have to call the delegate methods__ in `cellProvider` before and after you access the underlying data!
     
     Pros:
     - easy to use, minimum change to the original UIKit initializer
     
     Cons:
     - it is very likely that the code in `cellProvider` closure expression searches for an item by the item identifier.
     (item identifier just identifies the item, and very likely does not contain all the item propertites needed for display in collection view cell).
     The `cellContentProvider` closure expression very likely has to do the same search that the `cellprovider`
     has already done, but it was lost, because `cellProvider` returns just `UICollectionViewCell` .
     - For optimal performance, use the other initializer where the `cellProvider` parameter is replaced
     by `cellWithContentProvider` returning tuple `(UICollectionViewCell?, EquatableCellContent?)`.
     
     Bear in mind, that all the store of cell content and the related non-optimal efficiency is being done only for cells used by the collection view,
     (approx. twice as much as number of visible cells). So, using this initializer can still be very good choice for collection views where number of
     visible cells is small.
     
     - Parameters:
        - collectionView: collection view used with this diffable data source
        - cellProvider: returns the configured collection view cell. When delegate is set, do not forget to call the delegate methods before and
     after you access the underlying data.
        - cellContentProvider: returns `EquatableCellContent?` representing the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     The delegate methods are called automatically before and after this closure is executed.
     */
    public override init(
        collectionView: UICollectionView,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider,
        cellContentProvider: @escaping CellContentProvider
    ) {
        let customCellProvider = { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: ItemIdentifierType) -> UICollectionViewCell? in
            guard
                let thisDataSource = collectionView.dataSource as? Self,
                let cell = cellProvider(collectionView, indexPath, itemIdentifier)
            else { return nil }
            // thisDataSource is a workaround for self that is not yet available during initialization
            
            thisDataSource.delegate?.reloadingDataSource(thisDataSource, willReadItemForItemIdentifier: itemIdentifier)
            let cellContent = thisDataSource.cellContentProvider(itemIdentifier)
            thisDataSource.delegate?.reloadingDataSource(thisDataSource, didReadItemForItemIdentifier: itemIdentifier)
            
            thisDataSource.store(
                cellContent: cellContent,
                for: itemIdentifier,
                in: cell
            )
            return cell
        }
        super.init(collectionView: collectionView, cellProvider: customCellProvider)
        self.cellContentProvider = cellContentProvider
    }
    
    // required by ItemsReloadSupporting protocol
    override func willReadItem(for itemIdentifier: ItemIdentifierType) {
        delegate?.reloadingDataSource(self, willReadItemForItemIdentifier: itemIdentifier)
    }
    
    // required by ItemsReloadSupporting protocol
    override func didReadItem(for itemIdentifier: ItemIdentifierType) {
        delegate?.reloadingDataSource(self, didReadItemForItemIdentifier: itemIdentifier)
    }
    
}
