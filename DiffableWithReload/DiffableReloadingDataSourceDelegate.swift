//
//  DiffableReloadingDataSourceDelegate.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 08.03.2021.
//

public protocol DiffableReloadingDataSourceDelegate: AnyObject {
    associatedtype ItemIdentifierType: Hashable
    
    func willReadItem(for itemIdentifier: ItemIdentifierType)
    func didReadItem(for itemIdentifier: ItemIdentifierType)
}
