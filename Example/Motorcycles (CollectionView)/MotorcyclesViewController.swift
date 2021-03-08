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
    
    private var diffableDataSource: CollectionViewDiffableReloadingDataSource<SectionIdentifier, ItemIdentifier, Int>!  // Int for hashValue, just for demonstation
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
    
//    func increasePriceChangeColorAndShuffle(_ sender: Any) {
//        // change data in the cars array
//        cars.increasePriceOfAllCars(brand: .ford, by: 1)
//        cars.changeColorOfAllCars(brand: .volkswagen)
//        // create new snapshot
//        let snapshot = diffableDataSource.snapshot()
//        let itemIdentifiers = snapshot.itemIdentifiers.shuffled()
//        var newSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
//        newSnapshot.appendSections([.sectionOne])
//        newSnapshot.appendItems(itemIdentifiers)
//        // items for reload are automatically created
//        diffableDataSource.applyWithItemsReloadIfNeeded(newSnapshot, animatingDifferences: true)
//    }
    
}

private extension MotorcyclesViewController {
    
    func initializeDataSource() {
        diffableDataSource = CollectionViewDiffableReloadingDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            switch itemIdentifier {
            case .motorcycle(let vin):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOne", for: indexPath) as! CollectionViewCell
                // seek for a car with the vin
                guard let motorcycle = self?.motorcycles.first(where: {$0.vin == vin}) else { return cell }
                // car found, configure the cell
                cell.configure(price: "$\(motorcycle.price)", brand: motorcycle.brand.rawValue)
                return cell
            }
        } cellContentProvider: { [weak self] itemIdentifier in
            switch itemIdentifier {
            case .motorcycle(let vin):
                // seek for a car with the vin
                guard let motorcycle = self?.motorcycles.first(where: { $0.vin == vin }) else { return nil }
                // car has been found, return cell content data
                // do not include keypaths to properties that are not displayed in the cell!
                return HashableContent(of: motorcycle, using: \.brand.rawValue, \.price).hashValue
            }
        }
    }
    
    func initializeMotorcycles() {
        motorcycles = (0...19).map { _ in Motorcycle() }
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
