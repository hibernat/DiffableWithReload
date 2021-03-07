//
//  CarsAndMotorcyclesViewModel.swift
//  Example
//
//  Created by Michael Bernat on 22.02.2021.
//

import Foundation
import Combine

class CarsAndMotorcyclesViewModel {
    
    enum SectionIdentifier: Int {
        case sectionOne
        case sectionTwo
    }
    
    enum ItemIdentifier: Hashable, Equatable {
        case car(vin: String)
        case motorcycle(vin: Int)
    }
    
    struct TableViewIdentifiers: Equatable {
        var sectionIdentifiers: [SectionIdentifier]
        var itemIdentifiers: [SectionIdentifier: [ItemIdentifier]]
        private var underlyingDataChangeToggle: Bool = true  // once state should publish its value, with other values unchanged, just toggle this property
        
        init(cars: [Car], motorcycles: [Motorcycle], carsCountSectionOne: Int) {
            // set section identifiers
            sectionIdentifiers = [.sectionOne, .sectionTwo]
            // set items identifiers
            let carIdentifiersSectionOne = cars.prefix(carsCountSectionOne).map { ItemIdentifier.car(vin: $0.vin) }
            let carIdentifiersSectionTwo = cars.dropFirst(carsCountSectionOne).map { ItemIdentifier.car(vin: $0.vin) }
            let motorcycleIdentifiers = motorcycles.map { ItemIdentifier.motorcycle(vin: $0.vin) }
            itemIdentifiers = [
                .sectionOne: (carIdentifiersSectionOne + motorcycleIdentifiers).shuffled(),
                .sectionTwo: carIdentifiersSectionTwo
            ]
        }
    }
    
    @Published private(set) var tableViewIdentifiers: TableViewIdentifiers
    private var cars: [Car]
    private var motorcycles: [Motorcycle]
    
    init() {
        let carsCountSectionOne = 3
        let carsCountSectionTwo = 2
        let carsCount = carsCountSectionOne + carsCountSectionTwo
        let motorcyclesCount = 4
        // initialize cars
        cars = (0..<(carsCount - 2)).map { _ in Car() }
        cars.append(Car(brand: Car.fordBrand))
        cars.append(Car(brand: Car.volkswagenBrand))
        // initialize motorcycles
        motorcycles = (0..<motorcyclesCount).map { _ in Motorcycle() }
        // initialize tableViewIdentifiers
        tableViewIdentifiers = TableViewIdentifiers(cars: cars, motorcycles: motorcycles, carsCountSectionOne: carsCountSectionOne)
    }
    
    func cellViewModel(for itemIdentifier: ItemIdentifier) -> CellViewModel? {
        switch itemIdentifier {
        case .car(let vin):
            guard let car = car(with: vin) else { return nil }
            return CellViewModel(
                text: "\(car.brand) \(car.model) \(car.registrationPlate ?? "")",
                detailText: "\(car.price)",
                backgroundColorRed: car.colorRed,
                backgroundColorGreen: car.colorGreen,
                backgroundColorBlue: car.colorBlue
            )
        case .motorcycle(let vin):
            guard let motorcycle = motorcycle(with: vin) else { return nil }
            return CellViewModel(
                text: "\(motorcycle.brand) \(motorcycle.model) \(motorcycle.registrationPlate ?? "")",
                detailText: "\(motorcycle.price)",
                backgroundColorRed: 1,
                backgroundColorGreen: 1,
                backgroundColorBlue: 1
            )
        }
    }
    
    func switchSections() {
        // the goal is to publish all the changes at once
        var futureTableViewState = tableViewIdentifiers
        let firstSectionIdentifier = futureTableViewState.sectionIdentifiers.removeFirst()
        futureTableViewState.sectionIdentifiers.append(firstSectionIdentifier)
        tableViewIdentifiers = futureTableViewState
    }
    
}

private extension CarsAndMotorcyclesViewModel {
    
    func car(with vin: String) -> Car? {
        cars.first { $0.vin == vin }
    }
    
    func motorcycle(with vin: Int) -> Motorcycle? {
        motorcycles.first { $0.vin == vin }
    }
    
}
