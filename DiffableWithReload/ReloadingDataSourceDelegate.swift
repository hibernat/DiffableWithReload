//
//  ReloadingDataSourceDelegate.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 08.03.2021.
//

/**
 Delegate methods are called before and after any item is read using `cellContentProvider`.
 If the underlying data can be modified from another thread, use these delegate methods to implement
 appropriate read-lock.
 */
public protocol ReloadingDataSourceDelegate: AnyObject {
    associatedtype ItemIdentifierType: Hashable
    
    func reloadingDataSource(_ dataSource: Any, willReadItemForItemIdentifier itemIdentifier: ItemIdentifierType)
    func reloadingDataSource(_ dataSource: Any, didReadItemForItemIdentifier itemIdentifier: ItemIdentifierType)
}

public extension ReloadingDataSourceDelegate {
    
    /**
     Called just before any item is read using `cellContentProvider`.
     - Parameters:
        - dataSource: an instance of `TableViewDiffableReloadingDataSource` or `CollectionViewDiffableReloadingDataSource`
        - itemIdentifier: itemIdentifier that will be used as a parameter in `cellContentProvider` closure
     */
    func reloadingDataSource(_ dataSource: Any, willReadItemForItemIdentifier itemIdentifier: ItemIdentifierType) {
        
    }
    
    /**
     Called just after any item was read using `cellContentProvider`.
     - Parameters:
        - dataSource: an instance of `TableViewDiffableReloadingDataSource` or `CollectionViewDiffableReloadingDataSource`
        - itemIdentifier: itemIdentifier that was used as a parameter in `cellContentProvider` closure
     */
    func reloadingDataSource(_ dataSource: Any, didReadItemForItemIdentifier itemIdentifier: ItemIdentifierType) {
        
    }
    
}
