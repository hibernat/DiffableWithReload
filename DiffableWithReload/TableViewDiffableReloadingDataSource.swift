//
//  TableViewDiffableReloadingDataSource.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 10.03.2021.
//

import UIKit

/**
 Automatically remembers (stores) the content displayed by the table view cell.
 When any new snapshot is applied using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
 then items requiring reload are automaticaly identified, and are added to the applying snapshot.
 */
open class TableViewDiffableReloadingDataSource<
    SectionIdentifierType: Hashable,
    ItemIdentifierType: Hashable,
    EquatableCellContent: Equatable
>: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>, ItemsReloadSupporting {
    
    public typealias CellContentProvider = (ItemIdentifierType) -> EquatableCellContent?
    public typealias CellWithContentProvider = (UITableView, IndexPath, ItemIdentifierType) -> (cell: UITableViewCell?, cellContent: EquatableCellContent?)
    
    /// Returns the cell content value for the given item identifier.
    var cellContentProvider: CellContentProvider
    
    /// Maps the cells use by the table view to the content displayed in that cell.
    /// When table view cell is deallocated, the stored content object is also released.
    var cellContentMapTable = NSMapTable<UIView, CellContentObject<ItemIdentifierType, EquatableCellContent>>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    /**
     Automatically remembers (stores) the content displayed by the table view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`
     always reloads such an item identifier (table view cell).
     
     Pros:
     - optimized for performance
     - the code in `cellContentProvider` very likely gets an item data per given item identifier. Such a item data is used for configuring the table view cell,
     and can be also used for computing the `EquatableCellContent`. So, it is optimal to return not only the cell, but also the `EquatableCellContent`
     together in a tuple.
     
     Cons:
     - adds a bit of complexity
     - the return type varies from the original UIKit return value
     - it may be difficult to avoid code duplication, as the `EquatableCellContent` has to be returned both in `cellWithContentProvider`
     and `cellContentProvider` parameters.
     
     - Parameters:
        - tableView: table view used with this diffable data source
     - cellContentProvider: returns `EquatableCellContent?`. `EquatableCellContent?` represents the (visible) content of the cell and is used for resolving,
     whether the cell needs reload or not when new snapshot is being applied.
     - cellWithContentProvider: returns a tuple `(UITableViewCell?, EquatableCellContent?)`.  `UITableViewCell` is
     the configured cell, `EquatableCellContent?` represents the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     */
    public init(
        tableView: UITableView,
        cellContentProvider: @escaping CellContentProvider,
        cellWithContentProvider: @escaping CellWithContentProvider
    ) {
        let cellProvider: (UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell? = { tableView, indexPath, itemIdentifier in
            guard let thisDataSource = tableView.dataSource as? Self else { return nil }
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
     Automatically remembers (stores) the content displayed by the table view cells.
     The stored content (stored as `EquatableCellContent` type) resolves, whether the cell (item identifier) needs to be reloaded or not.
     The type `EquatableCellContent` must be equatable, and the natural choice is either `.data` property of ` EncodableContent`
     or `.hashValue` property of `HashableContent`. If the stored content value is `nil` then method
     `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`
     always reloads such an item identifier (table view cell).
     
     Pros:
     - easy to use, minimum change to the original UIKit initializer
     
     Cons:
     - it is very likely that the code in `cellProvider` closure expression searches for an item by the item identifier.
     (item identifier just identifies the item, and very likely does not contain all the item propertites needed for display in table view cell).
     The `cellContentProvider` closure expression very likely has to do the same search that the `cellprovider`
     has already done, but it was lost, because `cellProvider` returns just `UITableViewCell` .
     - For optimal performance, use the other initializer where the `cellProvider` parameter is replaced
     by `cellWithContentProvider` returning tuple `(UITableViewCell?, EquatableCellContent?)`.
     
     Bear in mind, that all the store of cell content and the related non-optimal efficiency is being done only for cells used by the table view,
     (approx. twice as much as number of visible cells). So, using this initializer can still be very good choice for table views where number of
     visible cells is small.
     
     - Parameters:
        - tableView: table view used with this diffable data source
        - cellProvider: returns the configured table view cell.
        - cellContentProvider: returns `EquatableCellContent?` representing the (visible) content of the cell. When any new snapshot is applied
     using `applyWithItemsReloadIfNeeded(_:, animatingDifferences:, reloadItemsAnimation:, completion:)`,
     then items requiring reload are identified using this stored value. (If the new cell content value varies from the stored one, the cell needs item reload.)
     */
    public init(
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider,
        cellContentProvider: @escaping CellContentProvider
    ) {
        let customCellProvider = { (tableView: UITableView, indexPath: IndexPath, itemIdentifier: ItemIdentifierType) -> UITableViewCell? in
            guard
                let thisDataSource = tableView.dataSource as? Self,
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
    
    /// The original initializer, only for internal use
    /// - Parameters:
    ///   - tableView: tableView
    ///   - cellProvider: cellProvider
    override init(
        tableView: UITableView,
        cellProvider: @escaping UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    ) {
        self.cellContentProvider = { _ in return nil }
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    /**
     In the first step, items (table view cells) that need reload, are identified by comparing the stored cell content and
     the potentially new cell content based on current value in the data source.
     The modified items  are then reloaded using `apply(_:, animatingDifferences: , completion:)`.
     Finally, the snapshot provided in the first parameter is applied by calling `apply(_:, animatingDifferences: , completion:)`.
     
     Please note that the UIKit method `apply(_:, animatingDifferences: , completion:)` is called twice.
     - first with current snapshot and `reloadItems` added
     - then with the supplied snapshot
     
     - Parameters:
        - snapshot: This shapshot should not contain any `reloadItems` as it makes no sense to do reload again.
        - animatingDifferences: If true, defautRowAnimation is used with the supplied snapshot
        - reloadItemsAnimation: if not nil, then this animation is used for item reload. If nil, items are reloaded with no animation.
        - completion: completion closure
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
            let currentItemIdentifiersSet = Set(currentSnapshotWithReloadItems.itemIdentifiers)
            let refinedItemIdentifiersForReload = itemIdentifiersForReload.filter { currentItemIdentifiersSet.contains($0) }
            currentSnapshotWithReloadItems.reloadItems(refinedItemIdentifiersForReload)
            if let reloadItemsAnimation = reloadItemsAnimation {
                // animated rows reloading
                let originalRowAnimation = defaultRowAnimation
                defaultRowAnimation = reloadItemsAnimation
                removeCellContentObjects(for: itemIdentifiersForReload)
                apply(currentSnapshotWithReloadItems, animatingDifferences: true)
                defaultRowAnimation = originalRowAnimation
            } else {
                // no animation for reloading rows
                removeCellContentObjects(for: itemIdentifiersForReload)
                apply(currentSnapshotWithReloadItems, animatingDifferences: false)
            }
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
