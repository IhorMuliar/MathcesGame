//
//  Storage.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//

import Foundation

let Storage = StorageContainer.shared

class StorageContainer {
	
	static let shared = StorageContainer()
	
	private init() { }
	
	let defaults = UserDefaults.standard
	
	fileprivate let encoder = PropertyListEncoder()
	fileprivate let decoder = PropertyListDecoder()
	
	var selectedCellMap: CellMap {
		get { return defaults[#function] ?? .level1 }
		set { defaults[#function] = newValue }
	}
	
	var highscores: [CellMap: SessionRecord] {
		get { return defaults[#function] ?? [:] }
		set { defaults[#function] = newValue }
	}
	
	var currentHighscore: SessionRecord? {
		get { return highscores[selectedCellMap] }
		set { highscores[selectedCellMap] = newValue }
	}
	
}

private extension UserDefaults {
	
	subscript <T: Codable>(_ key: String) -> T? {
		get {
			guard let data = data(forKey: key) else {
				return nil
			}
			do {
				return try Storage.decoder.decode([T].self, from: data).first
			} catch {
				print("UserDefaults decode error:", error)
				return nil
			}
		} set {
			guard let newValue = newValue else {
				removeObject(forKey: key)
				return
			}
			do {
				let newData = try Storage.encoder.encode([newValue])
				set(newData, forKey: key)
			} catch {
				print("UserDefaults encode error:", error)
			}
		}
	}
	
}

