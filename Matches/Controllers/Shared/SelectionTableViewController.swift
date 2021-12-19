//
//  SelectionTableViewController.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//


import UIKit

/// For setting up the table which has cells with checkmarks to toggle.
class SelectionTableViewController: GenericTableViewController {
    
    class var configs: [(title: String, isSet: Bool)] {
        return []
    }
    
    /// Represents a list of selected cells in this table.
    class var stateDescription: String {
        var description = ""
        for (config, isSet) in configs {
            if isSet {
                if !description.isEmpty {
                    description.append(", ")
                }
                description.append(config)
            }
        }
        if description.count > 26 {
            if configs.contains(where: { $0.1 == false }) {
                description = "Multiple"
            } else {
                description = "All enabled"
            }
        }
        return description
    }
    
    // Contains titles for cells with checkmarks.
    var cells: [(String, String)] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
	var selectedRow: (() -> IndexPath.Index)? = nil
    
    lazy var isCellSelectedAt: ((IndexPath.Index) -> Bool) = { [weak self] row in
        row == self?.selectedRow?()
    }
    
    var selectionHandler: ((IndexPath.Index) -> ())? = nil
    
    // MARK: - Table view data source
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
		cell.textLabel?.text = cells[indexPath.row].0
		cell.detailTextLabel?.text = cells[indexPath.row].1
        let isSelectedCell = isCellSelectedAt(indexPath.row)
        cell.accessoryType = isSelectedCell ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler?(indexPath.row)
        tableView.reloadData()
    }
    
}
