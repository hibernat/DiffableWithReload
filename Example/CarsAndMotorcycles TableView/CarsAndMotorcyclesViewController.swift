//
//  CarsAndMotorcyclesViewController.swift
//  Example
//
//  Created by Michael Bernat on 22.02.2021.
//

import UIKit
import DiffableWithReload

class CarsAndMotorcyclesViewController: UIViewController {

    var contentView: CarsAndMotorcyclesView { view as! CarsAndMotorcyclesView }
    private var viewModel = CarsAndMotorcyclesViewModel()
    
    override func viewDidLoad() {
        contentView.viewModel = viewModel
        super.viewDidLoad()
    }
 
    @IBAction func switchSections(_ sender: Any) {
        viewModel.switchSections()
    }
    
}
