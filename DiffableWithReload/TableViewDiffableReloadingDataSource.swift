//
//  TableViewDiffableReloadingDataSource.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 23.02.2021.
//

import UIKit

/// see quick help for type `TableViewDiffableReloadingDataSource`
public typealias TableViewDiffableEncodableDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable
> = TableViewDiffableReloadingDataSource<SectionIdentifierType, ItemIdentifierType, Data>

/// see quick help for type `TableViewDiffableReloadingDataSource`
public typealias TableViewDiffableHashableDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable
> = TableViewDiffableReloadingDataSource<SectionIdentifierType, ItemIdentifierType, Int>

/**
This diffable data source automatically remembers (stores) the content displayed by the table view cell.
When any new snapshot is applied using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
then items requiring reload are identified are automatically reloaded.
 */
open class TableViewDiffableReloadingDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable,
    EquatableCellContent: Equatable
>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>, ItemsReloadSupporting {
    
    /// Returns the cell content value for the given item identifier.
    var cellContentProvider: (ItemIdentifierType) -> EquatableCellContent?
    
    /// Maps the cells use by the table view to the content displayed in that cell.
    /// When table view cell is deallocated, the stored content object is also released.
    var cellContentMapTable = NSMapTable<UIView, CellContentObject<ItemIdentifierType, EquatableCellContent>>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    /**
     This diffable data source automatically remembers (stores) the content displayed by the table view cell.
     The stored content (stored as `EquatableCellContent` type) distinguishes, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `EncodableContent.data`
     or `HashableContent.hashValue` value. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`
     always reload such an item identifier (table view cell).
     
     Pros:
     - optimized for performance
     - once the code in `cellContentProvider` closure expression has available an item to configure the table view cell,
     you can also use the item properties to compute the `EquatableCellContent`, and return it together with the cell in a tuple.
     
     Cons:
     - the return type varies from the original UIKit return value
     - Parameters:
        - tableView: table view used with this diffable data source - no change to the UIKit functionality
        - cellWithContentProvider: returns `EquatableCellContent?` representing the (visible) content of the cell. The return value
     is used to obtain the new cell content when new snapshot should be applied, and then create `reloadItems` accordingly.
        - cellContentProvider: returns a tuple `(UITableViewCell?, EquatableCellContent?)`.  This diffable
     data source remembers the `EquatableCellContent` value for all cells used in the table view, and when any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
    */
    public init(
        tableView: UITableView,
        cellWithContentProvider: @escaping (UITableView, IndexPath, ItemIdentifierType) -> (cell: UITableViewCell?, cellContent: EquatableCellContent?),
        cellContentProvider: @escaping (ItemIdentifierType) -> EquatableCellContent?
    ) {
        let cellProvider: (UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell? = { tableView, indexPath, itemIdentifier in
            guard let thisDataSource = tableView.dataSource as? Self<SectionIdentifierType, ItemIdentifierType, EquatableCellContent>
            else { return nil }
            let cellWithContent = cellWithContentProvider(tableView, indexPath, itemIdentifier)
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
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    /**
     This diffable data source automatically remembers (stores) the content displayed by the table view cell.
     The stored content (stored as `EquatableCellContent` type) distinguishes, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `EncodableContent.data`
     or `HashableContent.hashValue` value. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`
     always reload such an item identifier (table view cell).
     
     Pros:
     - easy to use, minimum change to the original UIKit initializer
     
     Cons:
     - it is very likely that the code in `cellProvider` closure expression searches for an item by the item identifier.
     (item identifier just identifies the item, and very likely does not contain all the item propertites needed for display in table view cell)
     - the `cellContentProvider` closure expression very likely has to do the very same search (!!!) that the `cellprovider`
     has already done, but it was forgotten, because `cellProvider` returns just `UITableViewCell` .
     - __This is not optimal__
     For optimal performance. use the other initializer where the `cellProvider` parameter is replaced
     by the `cellWithContentProvider` parameter that returns a tuple `(UITableViewCell?, EquatableCellContent?)`.
     - Parameters:
        - tableView: table view used with this diffable data source - no change to the UIKit functionality
        - cellContentProvider: returns `EquatableCellContent?` representing the (visible) content of the cell. This diffable
     data source remembers this value for all cells used in the table view, and when new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
     then item requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
        - cellProvider: returns table view cell configured by the item identified by the item identifier - no change to the UIKit functionality
     */
    public init(
        tableView: UITableView,
        cellContentProvider: @escaping (ItemIdentifierType) -> EquatableCellContent?,
        cellProvider: @escaping UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    ) {
        let customCellProvider = { (tableView: UITableView, indexPath: IndexPath, itemIdentifier: ItemIdentifierType) -> UITableViewCell? in
            guard
                let thisDataSource = tableView.dataSource as? Self<SectionIdentifierType, ItemIdentifierType, EquatableCellContent>,
                let cell = cellProvider(tableView, indexPath, itemIdentifier)
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
        super.init(tableView: tableView, cellProvider: customCellProvider)
    }
    
    /**
     In the first step, items (table view cells) that need reload are identified using the stored cell content and the `cellContentProvider`
     set in the diffable data source initializer. The items (table view cells) identified the the first step, are then reloaded
     using `apply(_:, animatingDifferences: , completion:)`. Finally, the snapshot provided in the first
     parameter is applied to the table view.
     - Parameters:
        - snapshot: no change to the UIKit functionality. This shapshot should not contain any `reloadItems` as it makes
     no sense to do reload again.
        - animatingDifferences: no change to the UIKit functionality. If true, defautRowAnimation is used with the provided snapshot
        - reloadItemsAnimation: if not nil, then this animation is used for item reload. If nil, items are reloaded without any animation.
        - completion: no change to the UIKit functionality
     */
    public func applyWithItemsReloadIfNeeded(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animatingDifferences: Bool = true,
        reloadItemsAnimation: UITableView.RowAnimation? = nil,
        completion: (() -> Void)? = nil
    ) {
        let itemIdentifiersForReload = itemIdentifiersNeedingReload(from: snapshot.itemIdentifiers)
        if !itemIdentifiersForReload.isEmpty {
            // there are some item identifiers that need cell reload
            var currentSnapshotWithReloadItems = self.snapshot()
            currentSnapshotWithReloadItems.reloadItems(itemIdentifiersForReload)
            if let reloadItemsAnimation = reloadItemsAnimation {
                // animated rows reloading
                let originalRowAnimation = defaultRowAnimation
                defaultRowAnimation = reloadItemsAnimation
                apply(currentSnapshotWithReloadItems, animatingDifferences: true)
                defaultRowAnimation = originalRowAnimation
            } else {
                // no animation for reloading rows
                apply(currentSnapshotWithReloadItems, animatingDifferences: false)
            }
        }
        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
}
