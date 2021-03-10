//
//  CarsViewController.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import UIKit
import DiffableWithReload

class CarsViewController: UIViewController {
    
    enum SectionIdentifier: Int {
        case sectionOne
    }
    
    enum ItemIdentifier: Hashable {
        case car(vin: String)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var diffableDataSource: TableViewDiffableReloadingDataSource<SectionIdentifier, ItemIdentifier, Data>!
    private var cars: [Car]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCars()
        initializeDataSource()
        applyInitialSnapshot()
    }
    
    @IBAction func increasePriceOfAllFordCars(_ sender: Any) {
        // change data in the cars array
        cars.increasePriceOfAllCars(brand: .ford, by: 1)
        // and just apply the current snapshot
        let snapshot = diffableDataSource.snapshot()
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: true, reloadItemsAnimation: .left)
    }
    
    @IBAction func changeColorOfAllVolkswagenCars(_ sender: Any) {
        // change data in the cars array
        cars.changeColorOfAllCars(brand: .volkswagen)
        // and just apply the current snapshot
        let snapshot = diffableDataSource.snapshot()
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: false)
    }
    
    @IBAction func increasePriceChangeColorAndShuffle(_ sender: Any) {
        // change data in the cars array
        cars.increasePriceOfAllCars(brand: .ford, by: 1)
        cars.changeColorOfAllCars(brand: .volkswagen)
        // create new snapshot
        let snapshot = diffableDataSource.snapshot()
        let itemIdentifiers = snapshot.itemIdentifiers.shuffled()
        var newSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        newSnapshot.appendSections([.sectionOne])
        newSnapshot.appendItems(itemIdentifiers)
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(newSnapshot, animatingDifferences: true)
    }
    
}

private extension CarsViewController {
    
    func initializeDataSource() {
        diffableDataSource = TableViewDiffableReloadingDataSource(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) -> UITableViewCell in
            switch itemIdentifier {
            case .car(let vin):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
                // seek for a car with the vin
                guard let car = self?.cars.first(where: {$0.vin == vin}) else { return cell }
                // car found, configure the cell
                cell.textLabel?.text = "\(car.brand.rawValue) \(car.model) \(car.registrationPlate ?? "")"
                cell.detailTextLabel?.text = "$\(car.price)"
                cell.contentView.backgroundColor = UIColor(
                    red: CGFloat(car.colorRed),
                    green: CGFloat(car.colorGreen),
                    blue: CGFloat(car.colorBlue),
                    alpha: 1
                )
                return cell
            }
        } cellContentProvider: { [weak self] itemIdentifier in
            switch itemIdentifier {
            case .car(let vin):
                // seek for a car with the vin
                guard let car = self?.cars.first(where: { $0.vin == vin }) else { return nil }
                // car has been found, return cell content data
                // do not include keypaths to properties that are not displayed in the cell!
                return EncodableContent(of: car, using: \.brand.rawValue, \.model, \.registrationPlate, \.price, \.colorRed, \.colorGreen, \.colorBlue).data
            }
        }
    }
    
    func initializeCars() {
        cars = (0...19).map { _ in Car() }
        cars.insert(Car(brand: .ford), at: 2)
        cars.insert(Car(brand: .volkswagen), at: 4)
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        snapshot.appendSections([.sectionOne])
        let sectionOneItemIdentifiers = cars
            .map({ItemIdentifier.car(vin: $0.vin)})
            .shuffled()
        snapshot.appendItems(sectionOneItemIdentifiers, toSection: .sectionOne)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}
