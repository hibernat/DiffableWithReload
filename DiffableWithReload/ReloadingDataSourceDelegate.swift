//
//  TableViewDiffableReloadingDataSourceDelegate.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 08.03.2021.
//

public protocol ReloadingDataSourceDelegate: AnyObject {
    associatedtype ItemIdentifierType: Hashable
    
    func reloadingDataSource(_ : Any, willReadItemForItemIdentifier: ItemIdentifierType)
    func reloadingDataSource(_ : Any, didReadItemForItemIdentifier: ItemIdentifierType)
}

public extension ReloadingDataSourceDelegate {
    
    func reloadingDataSource(_ : Any, willReadItemForItemIdentifier: ItemIdentifierType) {
        
    }
    
    func reloadingDataSource(_ : Any, didReadItemForItemIdentifier: ItemIdentifierType) {
        
    }
    
}
