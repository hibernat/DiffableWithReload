//
//  ItemClass.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import Foundation

struct Motorcycle {
    
    static var vinCounter = 0  // used for generating unique identifiers
    
    enum Brand: String, CaseIterable {
        case ducati = "Ducati"
        case harleyDavidson = "Harley-Davidson"
        case kawasaki = "Kawasaki"
    }
    
    static let brands = Brand.allCases
    static let models: [Brand: [String]] = [
        .harleyDavidson: ["Fat Boy", "Breakout", "Tracer"],
        .kawasaki: ["Ninja", "Vulcan", "Concours"],
        .ducati: ["Panigale", "Multistrada", "Diavel", "Supersport"]
    ]
    
    let vin: Int // unique identifier
    var registrationPlate: String? // not every motorcycle has a registration plate
    let brand: Brand
    let model: String
    var price: Int
    var instructionManual: Data? // example of data that are not displayed in the table/collection view
    
    init(brand: Brand? = nil) {
        vin = Self.vinCounter
        Self.vinCounter += 1
        if Int.random(in: 0..<9) == 0 {
            registrationPlate = nil // motorcycle without registration plate
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
        self.brand = brand ?? Self.brands.randomElement()!
        model = Self.models[self.brand]!.randomElement()!
        price = Int.random(in: 5...15) * 1000
        instructionManual = Data(base64Encoded: UUID().uuidString)
    }
    
    mutating func increasePrice(by amount: Int) {
        price += amount
    }
    
    mutating func changeRegistrationPlate() {
        if Bool.random() {
            registrationPlate = nil // motorcycle without registration plate
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
    }
    
}

extension Array where Element == Motorcycle {
    
    mutating func increasePriceOfAllMotorcycles(brand: Motorcycle.Brand, by amount: Int) {
        for (index, motorcycle) in self.enumerated() where motorcycle.brand == brand {
            var updatedMotorcycle = motorcycle
            updatedMotorcycle.increasePrice(by: amount)
            self[index] = updatedMotorcycle
        }
    }
    
    mutating func changeRegistrationPlateOfAllMotorcycles(brand: Motorcycle.Brand) {
        for (index, motorcycle) in self.enumerated() where motorcycle.brand == brand {
            var updatedMotorcycle = motorcycle
            updatedMotorcycle.changeRegistrationPlate()
            self[index] = updatedMotorcycle
        }
    }
    
}
