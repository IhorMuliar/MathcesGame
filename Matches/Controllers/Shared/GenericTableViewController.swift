//
//  GenericTableViewController.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//

import UIKit

/// The `UITableViewController` subclass designed for convenience.
class GenericTableViewController: UITableViewController {
    
    let cellReuseIdentifier = "cellId"
    
    // Registers `GenericTableViewCell` for `cellReuseIdentifier`.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GenericTableViewCell", bundle: nil),
                           forCellReuseIdentifier: cellReuseIdentifier)
//		tableView.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    /// Convenience `Bool` toggling method.
    func toggle(_ boolean: inout Bool) {
        boolean = !boolean
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    }
    
}
