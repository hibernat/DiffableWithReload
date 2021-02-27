//
//  ItemStruct.swift
//  Example
//
//  Created by Michael Bernat on 18.02.2021.
//

import Foundation

class Car {
    
    static let brands = ["Audi", "BWM", "Chrysler", "Dodge", "Ford", "Honda", "Kia",
                         "Mercedes-Benz", "Porsche", "Tesla", "Toyota", "Volkswagen"]
    
    static let models = ["Panda", "Freemont", "Ducato", "Tipo", "Polo", "Golf", "ID.3", "Passat",
                         "Bora", "Jetta", "Arteon", "T-Roc", "Touareg", "Sharan", "Accord", "Civic",
                         "Legend", "Shuttle", "Rio", "Optima", "Sorento", "Soul", "Sportage",
                         "Stinger", "PT Cruiser", "Sebring", "Voyager", "Ranger", "Expedition",
                         "Mustang", "Bronco", "Edge", "Super Duty"]
    
    let vin: String // unique car identifier
    var registrationPlate: String? // not every car has a registration plate
    let brand: String
    let model: String
    var price: Int
    var colorRed: Float
    var colorGreen: Float
    var colorBlue: Float
    var instructionManual: Data? // example of data that are not displayed in the table/collection view
    
    init(brand: String?) {
        vin = UUID().uuidString
        if Int.random(in: 0...7) == 0 {
            registrationPlate = nil
        } else {
            registrationPlate = String(UUID().uuidString.prefix(6))
        }
        self.brand = brand ?? Self.brands.randomElement()!
        model = Self.models.randomElement()!
        price = Int.random(in: 3...50) * 1000
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
    
    func increasePriceOfAllCars(brand: String, by amount: Int) {
        for car in self where car.brand == brand {
            car.increasePrice(by: amount)
        }
    }
    
    func changeColorOfAllCars(brand: String) {
        for car in self where car.brand == brand {
            car.changeColor()
        }
    }
    
}
