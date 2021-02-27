//
//  CellContentObject.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 23.02.2021.
//

/// Object (instance of a class) storing the cellContent (probably `Data?` or `hashValue`) for an item identified by `itemIdentifier`
/// Cells, where the currently displayed and data source `cellContent` (or is `nil`) should be reloaded
class CellContentObject<ItemIdentifierType: Hashable, EquatableCellContent: Equatable> {
    let itemIdentifier: ItemIdentifierType
    var cellContent: EquatableCellContent?
    
    /**
     Object (instance of class) storing the cellContent (probably `Data?` or `hashValue`) for an item identified by `itemIdentifier`
     - Parameters:
        - itemIdentifier: item identifier used in the diffable data source
        - cellContent: equatable value representing the displayed content
     in the `UITableViewCell` or `UICollectionViewCell`. Cells,
     where the currently displayed and data source `cellContent` varies
     (or is `nil`) should be reloaded
     */
    init(itemIdentifier: ItemIdentifierType, cellContent: EquatableCellContent?) {
        self.itemIdentifier = itemIdentifier
        self.cellContent = cellContent
    }
}
