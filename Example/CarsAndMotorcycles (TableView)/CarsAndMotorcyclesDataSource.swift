//
//  CarsAndMotorcyclesDataSource.swift
//  Example
//
//  Created by Michael Bernat on 07.03.2021.
//

import UIKit
import DiffableWithReload

class CarsAndMotorcyclesDataSource: TableViewDiffableDelegatingDataSource<
    CarsAndMotorcyclesViewModel.SectionIdentifier,
    CarsAndMotorcyclesViewModel.ItemIdentifier,
    CarsAndMotorcyclesViewModel,
    Data
> {
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Section One"
        case 1: return "Section Two"
        default: fatalError("The example works only with 2 sections.")
        }
    }
    
}
