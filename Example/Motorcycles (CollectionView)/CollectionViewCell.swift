//
//  CollectionViewCell.swift
//  Example
//
//  Created by Michael Bernat on 07.03.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    func configure(price: String?, brand: String) {
        priceLabel.text = price
        brandLabel.text = brand
    }
}
