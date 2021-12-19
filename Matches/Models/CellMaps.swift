//
//  CellMaps.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//

import Foundation

enum CellMap: Int, Codable, CaseIterable {

	case level1 // 1x1
	case level2 // 2x2
	case level3 // 3x3
	case level4 // 4x4
	case level5 // 5x5
	case level6 // 5x5
	case level7 // 5x5
	case level8 // 5x5
	
	var title: String {
		switch self {
		case .level1: return "Level 1"
		case .level2: return "Level 2"
		case .level3: return "Level 3"
		case .level4: return "Level 4"
		case .level5: return "Level 5"
		case .level6: return "Level 6"
		case .level7: return "Level 7"
		case .level8: return "Level 8"
		}
	}
	
	var models: [CellModel] {
		switch self {
		case .level1: return CellModelGenerator<CellLevel1>.randomModels
		case .level2: return CellModelGenerator<CellLevel2>.randomModels
		case .level3: return CellModelGenerator<CellLevel3>.randomModels
		case .level4: return CellModelGenerator<CellLevel4>.randomModels
		case .level5: return CellModelGenerator<CellLevel5>.randomModels
		case .level6: return CellModelGenerator<CellLevel6>.randomModels
		case .level7: return CellModelGenerator<CellLevel7>.randomModels
		case .level8: return CellModelGenerator<CellLevel8>.randomModels
		}
	}
	
}

enum CellLevel1: Int, CaseIterable, CellInfo {
	case zero
	
	var titleFront: String {
		return String(rawValue)
	}
	
	var titleBack: String {
		return String(rawValue)
	}
	
}

enum CellLevel2: Int, CaseIterable, CellInfo {
	case zero
	case one
	
	var titleFront: String {
		return String(rawValue)
	}
	
	var titleBack: String {
		return String(rawValue)
	}
	
}

enum CellLevel3: Int, CaseIterable, CellInfo {
	case zero
	case one
	case two
	
	var titleFront: String {
		return String(rawValue)
	}
	
	var titleBack: String {
		return String(rawValue)
	}
	
}

enum CellLevel4: Int, CaseIterable, CellInfo {
	case one
	case two
	case three
	case four
	
	var titleFront: String {
		return String(rawValue+1)
	}
	
	var titleBack: String {
		return String(rawValue+1)
	}
	
}

enum CellLevel5: Int, CaseIterable, CellInfo {
	case one
	case two
	case three
	case four
	case five
	case six

	
	var titleFront: String {
		return String(rawValue+1)
	}
	
	var titleBack: String {
		return String(rawValue+1)
	}
	
}

enum CellLevel6: Int, CaseIterable, CellInfo {
	case one
	case two
	case three
	case four
	case five
	case six
	case seven
	case eight

	
	var titleFront: String {
		return String(rawValue+1)
	}
	
	var titleBack: String {
		return String(rawValue+1)
	}
	
}

enum CellLevel7: Int, CaseIterable, CellInfo {
	case one
	case two
	case three
	case four
	case five
	case six
	case seven
	case eight
	case nine

	
	var titleFront: String {
		return String(rawValue+1)
	}
	
	var titleBack: String {
		return String(rawValue+1)
	}
	
}

enum CellLevel8: Int, CaseIterable, CellInfo {
	case one
	case two
	case three
	case four
	case five
	case six
	case seven
	case eight
	case nine
	case ten

	
	var titleFront: String {
		return String(rawValue+1)
	}
	
	var titleBack: String {
		return String(rawValue+1)
	}
	
}
