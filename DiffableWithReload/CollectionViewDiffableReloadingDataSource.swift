//
//  CollectionViewDiffableReloadingDataSource.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 27.02.2021.
//

import UIKit

/// see quick help for type `CollectionViewDiffableReloadingDataSource`
public typealias CollectionViewDiffableEncodableDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable
> = CollectionViewDiffableReloadingDataSource<SectionIdentifierType, ItemIdentifierType, Data>

/// see quick help for type `CollectionViewDiffableReloadingDataSource`
public typealias CollectionViewDiffableHashableDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable
> = CollectionViewDiffableReloadingDataSource<SectionIdentifierType, ItemIdentifierType, Int>

/**
This diffable data source automatically remembers (stores) the content displayed by the collection view cell.
When any new snapshot is applied using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
then items requiring reload are identified are automatically reloaded.
 */
open class CollectionViewDiffableReloadingDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable,
    EquatableCellContent: Equatable
>: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>, ItemsReloadSupporting {
    
    /// Returns the cell content value for the given item identifier.
    var cellContentProvider: (ItemIdentifierType) -> EquatableCellContent?
    
    /// Maps the cells use by the collection view to the content displayed in that cell.
    /// When collection view cell is deallocated, the stored content object is also released.
    var cellContentMapTable = NSMapTable<UIView, CellContentObject<ItemIdentifierType, EquatableCellContent>>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    public init(
        collectionView: UICollectionView,
        cellWithContentProvider: @escaping (UICollectionView, IndexPath, ItemIdentifierType) -> (cell: UICollectionViewCell?, cellContent: EquatableCellContent?),
        cellContentProvider: @escaping (ItemIdentifierType) -> EquatableCellContent?
    ) {
        let cellProvider: (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell? = { collectionView, indexPath, itemIdentifier in
            guard let thisDataSource = collectionView.dataSource as? Self<SectionIdentifierType, ItemIdentifierType, EquatableCellContent>
            else { return nil }
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
    
    public init(
        collectionView: UICollectionView,
        cellContentProvider: @escaping (ItemIdentifierType) -> EquatableCellContent?,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    ) {
        let customCellProvider = { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: ItemIdentifierType) -> UICollectionViewCell? in
            guard
                let thisDataSource = collectionView.dataSource as? Self<SectionIdentifierType, ItemIdentifierType, EquatableCellContent>,
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
    
}
