//
//  ItemStruct.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import Foundation

// Car is a class just for demonstartion purposes, demonstrating that
// EncodableContent and HashableContent can work with both structs and classes
class Car {
    
    enum Brand: String, CaseIterable {
        case ford = "Ford"
        case volkswagen = "Volkswagen"
        case tesla = "Tesla"
        case toyota = "Toyota"
        case mercedesBenz = "Mercedes-Benz"
    }
        
    static let brands = Brand.allCases
    static let models: [Brand: [String]] = [
        .ford: ["Expedition", "Mustang", "Explorer", "Edge", "Super Duty"],
        .volkswagen: ["Golf", "ID.3", "Passat"],
        .tesla: ["Model X", "Model S", "Model Y"],
        .toyota: ["Camry", "Corolla", "Mirai", "RAV4"],
        .mercedesBenz: ["A-Class", "E-Class", "CLA", "CLS", "Maybach"],
    ]
    
    let vin: String // unique car identifier
    var registrationPlate: String? // not every car has a registration plate
    let brand: Brand
    let model: String
    var price: Int
    var colorRed: Float
    var colorGreen: Float
    var colorBlue: Float
    var instructionManual: Data? // example of data that are not displayed in the table/collection view
    
    init(brand: Brand? = nil) {
        vin = UUID().uuidString
        if Int.random(in: 0...7) == 0 {
            registrationPlate = nil // car without registration plate
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
        self.brand = brand ?? Self.brands.randomElement()!
        model = Self.models[self.brand]!.randomElement()!
        price = Int.random(in: 10...50) * 1000
        colorRed = Float.random(in: 0.5 ... 1)
        colorGreen = Float.random(in: 0.5 ... 1)
        colorBlue = Float.random(in: 0.5 ... 1)
        instructionManual = Data(base64Encoded: UUID().uuidString)
    }
    
    func increasePrice(by amount: Int) {
        price += amount
    }
    
    func changeColor() {
        colorRed = Float.random(in: 0.5 ... 1)
        colorGreen = Float.random(in: 0.5 ... 1)
        colorBlue = Float.random(in: 0.5 ... 1)
    }
}

extension Array where Element == Car {
    
    func increasePriceOfAllCars(brand: Car.Brand, by amount: Int) {
        for car in self where car.brand == brand {
            car.increasePrice(by: amount)
        }
    }
    
    func changeColorOfAllCars(brand: Car.Brand) {
        for car in self where car.brand == brand {
            car.changeColor()
        }
    }
    
}
