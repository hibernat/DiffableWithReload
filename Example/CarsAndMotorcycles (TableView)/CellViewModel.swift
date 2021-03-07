//
//  CellViewModel.swift
//  Example
//
//  Created by Michael Bernat on 07.03.2021.
//

import Foundation
import DiffableWithReload

struct CellViewModel {
    let text: String?
    let detailText: String?
    let backgroundColorRed: Float
    let backgroundColorGreen: Float
    let backgroundColorBlue: Float
    
    var cellContentData: Data? {
        EncodableContent(of: self, using: \.text, \.detailText, \.backgroundColorRed, \.backgroundColorGreen, \.backgroundColorBlue).data
    }
}
