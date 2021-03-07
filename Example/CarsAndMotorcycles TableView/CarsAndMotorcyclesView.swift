//
//  CarsAndMotorcyclesView.swift
//  Example
//
//  Created by Michael Bernat on 07.03.2021.
//

import UIKit
import Combine
import DiffableWithReload

class CarsAndMotorcyclesView: UIView {
    
    var viewModel: CarsAndMotorcyclesViewModel!
    
    private var tableView: UITableView!
    private var diffableDataSource: CarsAndMotorcyclesDataSource!
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            cancellables.removeAll() // unbind view model
        } else {
            bindViewModel() // bind view model once the table view is in window
        }
    }
    
    private func initialize() {
        tableView = (viewWithTag(100) as! UITableView)
        // initialize the diffable data source
        diffableDataSource = CarsAndMotorcyclesDataSource(tableView: tableView) { [weak self] itemIdentifier in
            // returns data uniquely identifying the cell content
            return self?.viewModel.cellViewModel(for: itemIdentifier)?.cellContentData
        } cellWithContentProvider: { [weak self] (tableView, indexPath, itemIdentifier) -> (UITableViewCell?, Data?) in
            // returns tuple of configured cell and cell content data
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOne", for: indexPath)
            // this is the only call to viewModel for data needed to configuring the cell, will be also used for computing the cellContentData
            guard let cellViewModel = self?.viewModel.cellViewModel(for: itemIdentifier) else { return (cell, nil) }
            // cell view model is available, configuring the cell
            cell.textLabel?.text = cellViewModel.text
            cell.detailTextLabel?.text = cellViewModel.detailText
            cell.contentView.backgroundColor = UIColor(
                red: CGFloat(cellViewModel.backgroundColorRed),
                green: CGFloat(cellViewModel.backgroundColorGreen),
                blue: CGFloat(cellViewModel.backgroundColorBlue),
                alpha: 1
            )
            // returning both the configured cell and data uniquely identifying the cell content
            return (cell, cellViewModel.cellContentData)
        }
    }
    
    private func bindViewModel() {
        viewModel.$tableViewIdentifiers
            .removeDuplicates()
            .sink { [weak self] identifiers in
                // tableViewIdentifiers has changed, no need to know, if/how the cars and motorcycles data has changed!
                guard let self = self else { return }
                // create new snapshot
                var newSnapshot = NSDiffableDataSourceSnapshot<
                    CarsAndMotorcyclesViewModel.SectionIdentifier,
                    CarsAndMotorcyclesViewModel.ItemIdentifier
                >()
                // set section identifiers in the snapshot
                newSnapshot.appendSections(identifiers.sectionIdentifiers)
                // set item identifiers in the snapshot
                for section in identifiers.sectionIdentifiers {
                    newSnapshot.appendItems(identifiers.itemIdentifiers[section] ?? [], toSection: section)
                }
                // apply snapshot
                self.diffableDataSource.applyWithItemsReloadIfNeeded(newSnapshot, animatingDifferences: true, reloadItemsAnimation: .right)
            }
            .store(in: &cancellables)
    }
}
