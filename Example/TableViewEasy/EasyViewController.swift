//
//  ViewController.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import UIKit
import DiffableWithReload

class ViewControllerTableViewEasy: UIViewController {
    
    static let ford = "Ford"
    static let volkswagen = "Volkswagen"
    
    enum SectionIdentifier: Int {
        case sectionOne
    }
    
    enum ItemIdentifier: Hashable {
        case car(vin: String)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var diffableDataSource: TableViewDiffableEncodableDataSource<SectionIdentifier, ItemIdentifier>!
    private var cars: [Car]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCars()
        initializeDataSource()
        applyInitialSnapshot()
    }
    
    @IBAction func increasePriceOfAllFordCars(_ sender: Any) {
        // change data in the cars array
        cars.increasePriceOfAllCars(brand: Self.ford, by: 100)
        // and just apply the current snapshot
        let snapshot = diffableDataSource.snapshot()
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: true, reloadItemsAnimation: .left)
    }
    
    @IBAction func changeColorOfAllVolkswagenCars(_ sender: Any) {
        // change data in the cars array
        cars.changeColorOfAllCars(brand: Self.volkswagen)
        // and just apply the current snapshot
        let snapshot = diffableDataSource.snapshot()
        // items for reload are automatically created
        diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: false)
    }
    
    @IBAction func increasePriceChangeColorAndShuffle(_ sender: Any) {
        // change data in the cars array
        cars.increasePriceOfAllCars(brand: Self.ford, by: 100)
        cars.changeColorOfAllCars(brand: Self.volkswagen)
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

private extension ViewControllerTableViewEasy {
    
    func initializeDataSource() {
        // this closure expression is used both in cellProvider and in cellContentProvider
        let cellContentData: (Car) -> Data? = { car in
            // just these keypaths are displayed in the cell, do not include keypaths to properties that are not displayed in the cell
            EncodableContent(of: car, using: \.brand, \.model, \.registrationPlate, \.price, \.colorRed, \.colorGreen, \.colorBlue).data
        }
        
        diffableDataSource = TableViewDiffableEncodableDataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .car(let vin):
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellOne", for: indexPath)
                // seek for a car with the vin
                guard let car = self.cars.first(where: {$0.vin == vin}) else { return (nil, nil) }
                // car found, configure the cell
                cell.textLabel?.text = "\(car.brand) \(car.model) \(car.registrationPlate ?? "")"
                cell.detailTextLabel?.text = "\(car.price)"
                cell.contentView.backgroundColor = UIColor(
                    red: CGFloat(car.colorRed),
                    green: CGFloat(car.colorGreen),
                    blue: CGFloat(car.colorBlue),
                    alpha: 1
                )
                // compute the cell content data
                let data = cellContentData(car)
                return (cell, data)
            }
        } cellContentProvider: { [unowned self] itemIdentifier in
            switch itemIdentifier {
            case .car(let vin):
                // seek for a car with the vin
                guard let car = self.cars.first(where: { $0.vin == vin }) else { return nil }
                // car has been found, return cell content data
                return cellContentData(car)
            }
        }
    }
    
    func initializeCars() {
        cars = (0...8).map { _ in Car.init(brand: nil) }
        cars.append(Car(brand: Self.ford))
        cars.append(Car(brand: Self.volkswagen))
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
