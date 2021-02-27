//
//  ItemsReloadSupporting.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 23.02.2021.
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
}

extension ItemsReloadSupporting {
    
    /**
     While the cell (UITableViewCell or UICollectionViewCell) is in use, this method stores both the item identifier
     and the cell content that the cell displays. The `cellContent` is used to decide whether the cell
     should be reloaded or not.
     The `cellCcontent` is kept only for items used by some cell in the table view or collection view.
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
        // is the itemIdentifier already used in some existing cell?
        let keyEnumerator = cellContentMapTable.keyEnumerator()
        var keyIterator = keyEnumerator.makeIterator()
        while let key = keyIterator.next() as? UIView {
            guard let object = cellContentMapTable.object(forKey: key) else { continue }
            if object.itemIdentifier == itemIdentifier {
                // yes, the itemIdentifier is already used, and can be dropped from the cellContentMapTable
                cellContentMapTable.removeObject(forKey: key)
                // there cannot be more objects for this itemIdentifier (doing this check on every store)
                break
            }
        }
        // cellContentMapTable does not contain any object for this itemIdentifier
        cellContentMapTable.setObject(cellContentObject, forKey: cell)
    }
    
    /**
     In `newItemIdentifiers` are found item identifiers that need cell reload. This task is accomplished by
     comparison of stored cell content and new cell content that is based on current value of the data source.
     - Parameter newItemIdentifiers: item identifiers intended to be applied to the table/collection view
     - Returns: subset of `newItemIdentifiers` that need reload
     */
    func itemIdentifiersNeedingReload(from newItemIdentifiers: [ItemIdentifierType]) -> [ItemIdentifierType] {
        var itemIdentifiersForReload: [ItemIdentifierType] = []
        guard let objectEnumerator = cellContentMapTable.objectEnumerator() else { return [] }
        var cellContentObjectIterator = objectEnumerator.makeIterator()
        // iterating over all stored content data, checking whether cell reload is needed
        while let cellContentObject = cellContentObjectIterator.next() as? CellContentObject<ItemIdentifierType, EquatableCellContent> {
            let itemIdentifier = cellContentObject.itemIdentifier
            if !newItemIdentifiers.contains(itemIdentifier) { continue }
            // new item identifiers contain identifier that is currently displayed in some cell
            if let newCellContent = cellContentProvider(itemIdentifier) {
                // new cell content is available
                if newCellContent != cellContentObject.cellContent {
                    // content has changed, cell must be reloaded
                    itemIdentifiersForReload.append(itemIdentifier)
                }
            } else {
                // new content data is nil, cell will be reloaded
                itemIdentifiersForReload.append(itemIdentifier)
            }
        }
        return itemIdentifiersForReload
    }
    
}
