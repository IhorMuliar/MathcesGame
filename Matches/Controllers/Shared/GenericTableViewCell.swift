//
//  GenericTableViewCell.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//


import UIKit

/// The `UITableViewCell` subclass designed for use in `GenericTableViewController` and its subclasses.
class GenericTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        detailTextLabel?.text = ""
    }
    
}
