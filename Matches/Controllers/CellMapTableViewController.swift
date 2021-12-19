//
//  MatchesCollectionViewController.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//

import Foundation

class CellMapTableViewController: SelectionTableViewController {
	
	let timeFormatter = DurationFormatter()
    
    // `SelectionTableViewController` setup goes here.
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Menu"
        let cellMaps = CellMap.allCases
		cells = cellMaps.map { ($0.title,
								"\(timeFormatter.string(from: Storage.highscores[$0]?.duration ?? 0)) / \(Storage.highscores[$0]?.tapsCount ?? 0)") }
        isCellSelectedAt = { row in
			// if row == cellMaps.firstIndex(of: Storage.selectedCellMap) {
            //    return true // defines selected cell map
            // }
            return false
        }
        selectionHandler = { [weak self] row in
            if cellMaps.indices.contains(row) {
                // select the cell map
                Storage.selectedCellMap = cellMaps[row]
				self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
