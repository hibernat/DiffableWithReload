//
//  MotorcyclesViewController.swift
//  Example
//
//  Created by Michael Bernat on 07.03.2021.
//

import UIKit
import DiffableWithReload

class MotorcyclesViewController: UIViewController {
    
    enum SectionIdentifier: Int {
        case sectionOne
    }
    
    enum ItemIdentifier: Hashable {
        case motorcycle(vin: Int)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diffableDataSource: CollectionViewDiffableReloadingDataSource<SectionIdentifier, ItemIdentifier, Int>!  // Int for hashValue, just for demonstration
    private var motorcycles: [Motorcycle]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMotorcycles()
        initializeDataSource()
        applyInitialSnapshot()
    }
    
    @IBAction func increasePriceOfAllHarleyDavidsonMotorcycles(_ sender: Any) {
        // change data in the motorcycles array
        motorcycles.increasePriceOfAllMotorcycles(brand: .harleyDavidson, by: 1)
        // and just apply the current snapshot
        let snapshot = diffableDataSource.snapshot()
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: true, animatingReloadItems: true)
    }
    
}

private extension MotorcyclesViewController {
    
    func initializeDataSource() {
        diffableDataSource = CollectionViewDiffableReloadingDataSource(collectionView: collectionView) {
            [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            switch itemIdentifier {
            case .motorcycle(let vin):
                // seek for a motorcycle with the vin
                guard let motorcycle = self?.motorcycles.first(where: {$0.vin == vin}) else {
                    fatalError("Unexpected state, missing motorcycle")
                }
                // motorcycle found, choose cell
                let cellReuseIdentifier: String
                if motorcycle.price.isMultiple(of: 7) {
                    cellReuseIdentifier = "MotorcycleCell2"
                } else if motorcycle.price.isMultiple(of: 3) {
                    cellReuseIdentifier = "MotorcycleCell1"
                } else {
                    cellReuseIdentifier = "MotorcycleCell0"
                }
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: cellReuseIdentifier,
                    for: indexPath
                ) as! CollectionViewCell
                // configure the cell
                cell.configure(price: "$\(motorcycle.price)", brand: motorcycle.brand.rawValue)
                return cell
            }
        } cellContentProvider: { [weak self] itemIdentifier in
            switch itemIdentifier {
            case .motorcycle(let vin):
                // seek for a motorcycle by the vin
                guard let motorcycle = self?.motorcycles.first(where: { $0.vin == vin }) else { return nil }
                // motorcycle has been found, return cell content data
                // do not include keypaths to properties that are not displayed in the cell!
                return HashableContent(of: motorcycle, using: \.brand.rawValue, \.price).hashValue
            }
        }
    }
    
    func initializeMotorcycles() {
        motorcycles = (0...1000).map { _ in Motorcycle() }
        motorcycles.insert(Motorcycle(brand: .harleyDavidson), at: 2)
        motorcycles.insert(Motorcycle(brand: .harleyDavidson), at: 4)
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        snapshot.appendSections([.sectionOne])
        let sectionOneItemIdentifiers = motorcycles
            .map({ItemIdentifier.motorcycle(vin: $0.vin)})
            .shuffled()
        snapshot.appendItems(sectionOneItemIdentifiers, toSection: .sectionOne)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}
