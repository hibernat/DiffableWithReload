//
//  CollectionViewDiffableReloadingDataSource.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 27.02.2021.
//

import UIKit

/**
 Automatically remembers (stores) the content displayed by the collection view cell.
 When any new snapshot is applied using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
 then items requiring reload are automaticaly identified, and are added to the snapshot being applied.
 */
open class CollectionViewDiffableReloadingDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable,
    EquatableCellContent: Equatable
>: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>, ItemsReloadSupporting {
    
    public typealias CellContentProvider = (ItemIdentifierType) -> EquatableCellContent?
    public typealias CellWithContentProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> (cell: UICollectionViewCell?, cellContent: EquatableCellContent?)
    
    /// Returns the cell content value for the given item identifier.
    var cellContentProvider: CellContentProvider
    
    /// Maps the cells use by the collection view to the content displayed in that cell.
    /// When collection view cell is deallocated, the stored content object is also released.
    var cellContentMapTable = NSMapTable<UIView, CellContentObject<ItemIdentifierType, EquatableCellContent>>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    /**
     Automatically remembers (stores) the content displayed by the collection view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`
     always reloads such an item identifier (collection view cell).
     
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
     whether the cell needs reload or not when new snapshot is being applied.
        - cellWithContentProvider: returns a tuple `(UICollectionViewCell?, EquatableCellContent?)`.  `UICollectionViewCell` is
     the configured cell, `EquatableCellContent?` represents the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     */
    public init(
        collectionView: UICollectionView,
        cellContentProvider: @escaping CellContentProvider,
        cellWithContentProvider: @escaping CellWithContentProvider
    ) {
        let cellProvider: (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell? = { collectionView, indexPath, itemIdentifier in
            guard let thisDataSource = collectionView.dataSource as? Self else { return nil }
            let cellWithContent = cellWithContentProvider(collectionView, indexPath, itemIdentifier)
            guard let cell = cellWithContent.cell else { return nil }
            // thisDataSource is a workaround for self that is not yet available during initialization
            thisDataSource.store(
                cellContent: cellWithContent.cellContent,
                for: itemIdentifier,
                in: cell
            )
            return cell
        }
        self.cellContentProvider = cellContentProvider
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    /**
     Automatically remembers (stores) the content displayed by the collection view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`
     always reloads such an item identifier (collection view cell).
     
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
        - cellProvider: returns the configured collection view cell.
        - cellContentProvider: returns `EquatableCellContent?` representing the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, animatingReloadItems:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     */
    public init(
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
            let cellContent = thisDataSource.cellContentProvider(itemIdentifier)
            thisDataSource.store(
                cellContent: cellContent,
                for: itemIdentifier,
                in: cell
            )
            return cell
        }
        self.cellContentProvider = cellContentProvider
        super.init(collectionView: collectionView, cellProvider: customCellProvider)
    }
    
    /// The original initializer, only for internal use
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - cellProvider: cellProvider
    override init(
        collectionView: UICollectionView,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    ) {
        self.cellContentProvider = { _ in return nil }
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    /**
     In the first step, items (collection view cells) that need reload are identified by comparing the stored cell content and
     the potentially new cell content based on current value in the data source.
     The modified items  are then reloaded using `apply(_:, animatingDifferences: , completion:)`.
     Finally, the snapshot provided in the first parameter is applied by calling `apply(_:, animatingDifferences: , completion:)`.
     
     Please note that the UIKit method `apply(_:, animatingDifferences: , completion:)` is called twice.
     - first with current snapshot and `reloadItems` added
     - then with the supplied snapshot
     
     - Parameters:
        - snapshot: This shapshot should not contain any `reloadItems` as it makes no sense to do reload again.
        - animatingDifferences: If true, the supplied snapshot differences are animated.
        - animatingReloadItems: If true, the calculated item reloads are animated.
        - completion: completion closure
     */
    public func applyWithItemsReloadIfNeeded(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animatingDifferences: Bool = true,
        animatingReloadItems: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let itemIdentifiersForReload = itemIdentifiersNeedingReload(from: snapshot.itemIdentifiers)
        if !itemIdentifiersForReload.isEmpty {
            // there are some item identifiers that need cell reload
            var currentSnapshotWithReloadItems = self.snapshot()
            let currentItemIdentifiersSet = Set(currentSnapshotWithReloadItems.itemIdentifiers)
            let refinedItemIdentifiersForReload = itemIdentifiersForReload.filter { currentItemIdentifiersSet.contains($0) }
            currentSnapshotWithReloadItems.reloadItems(refinedItemIdentifiersForReload)
            removeCellContentObjects(for: itemIdentifiersForReload)
            apply(currentSnapshotWithReloadItems, animatingDifferences: animatingReloadItems)
        }
        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    // required by ItemsReloadSupporting protocol
    func willReadItem(for itemIdentifier: ItemIdentifierType) {
    
    }
    
    // required by ItemsReloadSupporting protocol
    func didReadItem(for itemIdentifier: ItemIdentifierType) {
    
    }
    
}
