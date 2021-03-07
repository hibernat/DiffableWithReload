//
//  CarsAndMotorcyclesViewModel.swift
//  Example
//
//  Created by Michael Bernat on 22.02.2021.
//

import Foundation
import Combine

class CarsAndMotorcyclesViewModel {
    
    typealias ItemIdentifiersDirectory = [SectionIdentifier: [ItemIdentifier]]
    
    enum SectionIdentifier: Int {
        case sectionOne
        case sectionTwo
    }
    
    enum ItemIdentifier: Hashable, Equatable {
        case car(vin: String)
        case motorcycle(vin: Int)
        
        var isCar: Bool { if case .car = self { return true } else { return false } }
        var isMotorcycle: Bool { if case .motorcycle = self { return true } else { return false } }
    }
    
    struct TableViewIdentifiers: Equatable {
        var sectionIdentifiers: [SectionIdentifier]
        var itemIdentifiersDirectory: ItemIdentifiersDirectory
        fileprivate var underlyingDataChangeToggle: Bool = true  // once identifiers should publish its value, with other values unchanged, just toggle this property
        
        init(cars: [Car], motorcycles: [Motorcycle], carsCountSectionOne: Int) {
            // set section identifiers
            sectionIdentifiers = [.sectionOne, .sectionTwo]
            // set items identifiers
            let carIdentifiersSectionOne = cars.prefix(carsCountSectionOne).map { ItemIdentifier.car(vin: $0.vin) }
            let carIdentifiersSectionTwo = cars.dropFirst(carsCountSectionOne).map { ItemIdentifier.car(vin: $0.vin) }
            let motorcycleIdentifiers = motorcycles.map { ItemIdentifier.motorcycle(vin: $0.vin) }
            itemIdentifiersDirectory = [
                .sectionOne: (carIdentifiersSectionOne + motorcycleIdentifiers).shuffled(),
                .sectionTwo: carIdentifiersSectionTwo
            ]
        }
    }
    
    @Published private(set) var tableViewIdentifiers: TableViewIdentifiers
    private var cars: [Car]
    private var motorcycles: [Motorcycle]
    
    init() {
        let carsCountSectionOne = 4
        let carsCountSectionTwo = 2
        let carsCount = carsCountSectionOne + carsCountSectionTwo
        let motorcyclesCount = 5
        // initialize cars
        cars = (0..<(carsCount - 2)).map { _ in Car() }
        cars.append(Car(brand: .ford))
        cars.append(Car(brand: .ford))
        // initialize motorcycles
        motorcycles = (0..<(motorcyclesCount - 2)).map { _ in Motorcycle() }
        motorcycles.append(Motorcycle(brand: .ducati))
        motorcycles.append(Motorcycle(brand: .ducati))
        // initialize tableViewIdentifiers
        tableViewIdentifiers = TableViewIdentifiers(cars: cars, motorcycles: motorcycles, carsCountSectionOne: carsCountSectionOne)
    }
    
    func cellViewModel(for itemIdentifier: ItemIdentifier) -> CellViewModel? {
        switch itemIdentifier {
        case .car(let vin):
            guard let car = car(with: vin) else { return nil }
            return CellViewModel(
                text: "\(car.brand.rawValue) \(car.model) \(car.registrationPlate ?? "")",
                detailText: "\(car.price)",
                backgroundColorRed: car.colorRed,
                backgroundColorGreen: car.colorGreen,
                backgroundColorBlue: car.colorBlue
            )
        case .motorcycle(let vin):
            guard let motorcycle = motorcycle(with: vin) else { return nil }
            return CellViewModel(
                text: "\(motorcycle.brand.rawValue) \(motorcycle.model) \(motorcycle.registrationPlate ?? "")",
                detailText: "\(motorcycle.price)",
                backgroundColorRed: 1,
                backgroundColorGreen: 1,
                backgroundColorBlue: 1
            )
        }
    }
    
    func increasePriceOfFordCars() {
        cars.increasePriceOfAllCars(brand: .ford, by: 1)
        tableViewIdentifiers.underlyingDataChangeToggle.toggle()
    }
    
    func changeRegistrationPlatesOfDucatiMotorcycles() {
        motorcycles.changeRegistrationPlateOfAllMotorcycles(brand: .ducati)
        tableViewIdentifiers.underlyingDataChangeToggle.toggle()
    }
    
    func increasePriceChangePlatesAndMoveMotorcycle() {
        cars.increasePriceOfAllCars(brand: .ford, by: 1) // tableViewIdentifiers is not changed, no value is published!
        motorcycles.changeRegistrationPlateOfAllMotorcycles(brand: .ducati) // tableViewIdentifiers is not changed, no value is published!
        let sectionFrom: SectionIdentifier
        let sectionTo: SectionIdentifier
        if tableViewIdentifiers.itemIdentifiersDirectory[.sectionOne]?.contains(where: { $0.isMotorcycle }) == true {
            // there is a motorcycle in sectionOne
            sectionFrom = .sectionOne
            sectionTo = .sectionTwo
        } else {
            // there is no motorcycle in sectionOne, thus moving from sectionTwo
            sectionFrom = .sectionTwo
            sectionTo = .sectionOne
        }
        // creating new copy of tableViewIdentifiers
        var newTableViewIdentifiers = tableViewIdentifiers(
            withMovedMotorcycleFrom: sectionFrom,
            to: sectionTo
        )
        newTableViewIdentifiers.underlyingDataChangeToggle.toggle() // this guarantees that tableViewIdentifiers will publish new value
        tableViewIdentifiers = newTableViewIdentifiers // everything is set at once, and one value is published to subscribers
    }
    
    func switchSections() {
        // newTableViewIdentifiers are needed to publish all the changes at once
        var newTableViewIdentifiers = tableViewIdentifiers
        let firstSectionIdentifier = newTableViewIdentifiers.sectionIdentifiers.removeFirst()
        newTableViewIdentifiers.sectionIdentifiers.append(firstSectionIdentifier)
        tableViewIdentifiers = newTableViewIdentifiers  // and now new value of tableViewIdentifiers is published
    }
    
}

private extension CarsAndMotorcyclesViewModel {
    
    func car(with vin: String) -> Car? {
        cars.first { $0.vin == vin }
    }
    
    func motorcycle(with vin: Int) -> Motorcycle? {
        motorcycles.first { $0.vin == vin }
    }
    
    func tableViewIdentifiers(
        withMovedMotorcycleFrom sectionFrom: SectionIdentifier,
        to sectionTo: SectionIdentifier
    ) -> TableViewIdentifiers {
        guard var itemIdentifiersFrom = tableViewIdentifiers.itemIdentifiersDirectory[sectionFrom],
            let index = itemIdentifiersFrom.lastIndex(where: { $0.isMotorcycle }) else {
            // there is no motorcycle in sectionFrom
            return tableViewIdentifiers
        }
        // last motorcycle identifier in sectionFrom found
        let movingMotorcycleIdentifier = itemIdentifiersFrom[index]
        itemIdentifiersFrom.remove(at: index)
        let itemIdentifiersTo = [movingMotorcycleIdentifier] + (tableViewIdentifiers.itemIdentifiersDirectory[sectionTo] ?? [])
        // making copy of current itemIdentifiersDirectory
        var itemIdentifiersDirectory = tableViewIdentifiers.itemIdentifiersDirectory
        itemIdentifiersDirectory[sectionFrom] = itemIdentifiersFrom
        itemIdentifiersDirectory[sectionTo] = itemIdentifiersTo
        // making copy of the tableViewIdentifiers
        var newTableViewIdentifiers = tableViewIdentifiers
        newTableViewIdentifiers.itemIdentifiersDirectory = itemIdentifiersDirectory
        return newTableViewIdentifiers
    }
    
}
