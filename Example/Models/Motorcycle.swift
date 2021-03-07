//
//  ItemClass.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import Foundation

struct Motorcycle {
    
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
        vin = Int.random(in: Int.min...Int.max)  // unique identifier (for this example purposes is unique)
        if Int.random(in: 0...7) == 0 {
            registrationPlate = nil // motorcycle without registration plate
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
        self.brand = brand ?? Self.brands.randomElement()!
        model = Self.models[self.brand]!.randomElement()!
        price = Int.random(in: 3...50) * 1000
        instructionManual = Data(base64Encoded: UUID().uuidString)
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
    
    mutating func changeRegistrationPlateOfAllMotorcycles(brand: Motorcycle.Brand) {
        for (index, motorcycle) in self.enumerated() where motorcycle.brand == brand {
            var updatedMotorcycle = motorcycle
            updatedMotorcycle.changeRegistrationPlate()
            self[index] = updatedMotorcycle
        }
    }
    
}
