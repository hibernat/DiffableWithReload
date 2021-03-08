//
//  ItemsReloadSupporting.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 08.03.2021.
//

import UIKit

/// Extension to this protocol shares code for both table view and collection view diffable data sources
protocol ItemsReloadSupporting {
    associatedtype ItemIdentifierType: Hashable
    associatedtype EquatableCellContent: Equatable
    
    var cellContentProvider: (ItemIdentifierType) -> EquatableCellContent? { get }
    var cellContentMapTable: NSMapTable<UIView, CellContentObject<ItemIdentifierType, EquatableCellContent>> { get }
    
    func store(cellContent: EquatableCellContent?, for itemIdentifier: ItemIdentifierType, in view: UIView)
    func itemIdentifiersNeedingReload(from newItemIdentifiers: [ItemIdentifierType]) -> [ItemIdentifierType]
    func willReadItem(for itemIdentifier: ItemIdentifierType)
    func didReadItem(for itemIdentifier: ItemIdentifierType)
}

extension ItemsReloadSupporting {
    
    /**
     Stores the item identifier and the cell content that the cell displays, while the cell (UITableViewCell or UICollectionViewCell) is in use.
     The `cellContent` is used to decide whether the cell should be reloaded or not.
     - Parameters:
        - cellContent: content (data, hash value or anything Equatable) describing (identifying) the displayed content in the cell.
     Use `EncodableContent` type and `.data` property, or `HashableContent` type and `.hashValue` property for
     an easy creation of the cell content. The only requirement on this type is being Equatable, so any other ways of getting
     the cell content are possible.
        - itemIdentifier: item identifier of the item that configured the cell
        - cell: view that was configured by this `cellContent`, expected is `UITableViewCell` or `UICollectionViewCell`
     */
    func store(cellContent: EquatableCellContent?, for itemIdentifier: ItemIdentifierType, in cell: UIView) {
        let cellContentObject = CellContentObject<ItemIdentifierType, EquatableCellContent>(
            itemIdentifier: itemIdentifier,
            cellContent: cellContent
        )
        // key is the cell
        // value is the cellContent
        cellContentMapTable.setObject(cellContentObject, forKey: cell)
    }
    
    /**
     Removes all the stored objects for given item identifiers. Important to do just before these item identifiers are reloaded.
     Very likely is the same item identifier used at more cell content objects stored, and removal of all such an objects
     just before reload keeps data consistent.
     - Parameter itemIdentifiers: an array of item identifiers for which the `CellContentObject` objects are removed
     */
    func removeCellContentObjects(for itemIdentifiers: [ItemIdentifierType]) {
        let keyEnumerator = cellContentMapTable.keyEnumerator()
        var keyIterator = keyEnumerator.makeIterator()
        var removingKeys: [UIView] = []
        // iterating over all stored objects
        while let key = keyIterator.next() as? UIView {
            guard let object = cellContentMapTable.object(forKey: key) else {
                // for this cell is no stored cellContent
                continue
            }
            if itemIdentifiers.contains(object.itemIdentifier) {
                // object for this key should be removed
                removingKeys.append(key)
            }
        }
        // remove all objects that store information about any of itemIdentifiers
        for key in removingKeys {
            cellContentMapTable.removeObject(forKey: key)
        }
    }
    
    /**
     Searches for item identifiers that need cell reload in `newItemIdentifiers`. This task is accomplished by
     comparing stored cell content to the new cell content that is based on current value of the data source.
     - Parameter newItemIdentifiers: item identifiers intended to be applied to the table/collection view in a snapshot
     - Returns: subset of `newItemIdentifiers` that needs reload
     */
    func itemIdentifiersNeedingReload(from newItemIdentifiers: [ItemIdentifierType]) -> [ItemIdentifierType] {
        var itemIdentifiersForReload: Set<ItemIdentifierType> = []
        guard let objectEnumerator = cellContentMapTable.objectEnumerator() else { return [] }
        var cellContentObjectIterator = objectEnumerator.makeIterator()
        // iterating over all stored content data, checking whether cell reload is needed
        while let cellContentObject = cellContentObjectIterator.next() as? CellContentObject<ItemIdentifierType, EquatableCellContent> {
            let itemIdentifier = cellContentObject.itemIdentifier
            guard newItemIdentifiers.contains(itemIdentifier) else {
                // identifier is currently displayed in table/collection view, but is not in the new snapshot
                // no need to reload
                continue
            }
            // new item identifiers contain identifier that is currently displayed in some cell
            willReadItem(for: itemIdentifier)
            if let newCellContent = cellContentProvider(itemIdentifier) {
                // new cell content is available
                didReadItem(for: itemIdentifier)
                if newCellContent != cellContentObject.cellContent {
                    // content has changed, cell must be reloaded
                    itemIdentifiersForReload.insert(itemIdentifier)
                }
            } else {
                // new content data is nil, cell will be reloaded
                didReadItem(for: itemIdentifier)
                itemIdentifiersForReload.insert(itemIdentifier)
            }
        }
        return Array(itemIdentifiersForReload)
    }
    
}

