//
//  ItemClass.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import Foundation

struct Motorcycle {
    
    static let ducati = "Ducati"
    static let Honda = "Honda"
    
    static let brands = ["Harley-Davidson", "Honda", "Yamaha", "KTM", "Ducati", "Aprilia", "Kawasaki"]
    
    static let models = ["Fat Boy", "Breakout", "Tracer", "Ninja", "Versys", "Concours", "Tuono", "Dorsoduro"]
    
    let vin: Int // unique identifier
    var registrationPlate: String? // not every motorcycle has a registration plate
    let brand: String
    let model: String
    var price: Int
    var instructionManual: Data? // example of data that are not displayed in the table/collection view
    
    init(brand: String? = nil) {
        vin = Int.random(in: Int.min...Int.max)  // unique identifier (for this example purposes is unique)
        if Int.random(in: 0...7) == 0 {
            registrationPlate = nil // motorcycle without registration plate
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
        self.brand = brand ?? Self.brands.randomElement()!
        model = Self.models.randomElement()!
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
