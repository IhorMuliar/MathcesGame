//
//  MatchesCollectionViewController.swift
//  Marches
//
//  Created by MacBook on 19.12.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

private let headerId = "Header"

class MatchesCollectionViewController: UIViewController {
	
	@IBOutlet private(set) weak var skipButton: UIBarButtonItem?
	@IBOutlet weak var recordTimeLabel: UILabel!
	@IBOutlet weak var recordCounterLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var counterLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var cellModels: [CellModel] = []
	var activeCellIndex: Int? = nil
	var resetting: Bool = false
	let timeFormatter = DurationFormatter()
	var counter: Timer = Timer()
	var progress: Int = 0
	
	var tapsCount: Int = 0 {
		didSet {
			counterTick()
		}
	}
	
	var start: Date? = nil {
		didSet {
			counterTick()
		}
	}
	
	deinit {
		counter.invalidate()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refresh()
	}
	
	// MARK: - IBActions
	
	@IBAction func settings() {
		navigationController?.pushViewController(CellMapTableViewController(), animated: true)
	}
	
	@IBAction func nextMap() {
		let currentMap = Storage.selectedCellMap
		let allMaps = CellMap.allCases
		guard let currentMapIndex = allMaps.firstIndex(of: currentMap) else { return }
		let nextMapIndex = currentMapIndex + 1
		if allMaps.indices.contains(nextMapIndex) {
			Storage.selectedCellMap = allMaps[nextMapIndex]
		} else {
			Storage.selectedCellMap = allMaps[0]
		}
		refresh()
	}
	
	@IBAction func refresh() {
		counter.invalidate()
		skipButton?.isEnabled = false
		activeCellIndex = nil
		let selectedMap = Storage.selectedCellMap
		cellModels = selectedMap.models
		tapsCount = 0
		start = nil
		progress = 0
		title = selectedMap.title
		collectionView?.reloadData()
		if let highscore = Storage.currentHighscore {
			recordTimeLabel.text = "Highscore: \(timeFormatter.string(from: highscore.duration))"
			recordCounterLabel.text = "Taps: \(highscore.tapsCount)"
		} else {
			recordTimeLabel.text = "Highscore: 00:00:00"
			recordCounterLabel.text = "Taps: 0"
		}
	}
	
	@objc func counterTick() {
		if let start = start {
			timeLabel.text = "Time: \(timeFormatter.string(from: Date().timeIntervalSince(start)))"
		} else {
			timeLabel.text = "Time: 00:00:00"
		}
		counterLabel.text = "Taps: \(tapsCount)"
	}
	
}

// MARK: - UICollectionViewDataSource

extension MatchesCollectionViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		return cellModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = cellModels[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MatchCollectionViewCell
		cell.layer.cornerRadius = 4
		cell.backgroundColor = .lightGray
		cell.contentView.backgroundColor = model.color
		cell.titleLabel.text = model.title
		cell.titleLabel.textColor = model.textColor
		cell.titleLabel.isHidden = model.titleIsHidden
		return cell
	}
	
}

// MARK: - UICollectionViewDelegate

extension MatchesCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView,
						shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let model = cellModels[indexPath.row]
		return model.state != .disabled
	}
	
	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		let model = cellModels[indexPath.row]
		if resetting {
			for model in cellModels where model.state == .selected {
				model.state = .closed
			}
			model.state = .selected
			activeCellIndex = indexPath.row
			resetting = false
		} else {
			if let index = activeCellIndex {
				if indexPath.row != index {
					if model.selectedColor == cellModels[index].selectedColor {
						model.state = .disabled
						self.cellModels[index].state = .disabled
						progress += 1
						activeCellIndex = nil
					} else {
						model.state = .selected
						resetting = true
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							if self.resetting {
								model.state = .closed
								self.cellModels[index].state = .closed
								self.activeCellIndex = nil
								collectionView.reloadData()
								self.resetting = false
							}
						}
					}
				} else {
					return
				}
			} else {
				model.state = .selected
				activeCellIndex = indexPath.row
			}
		}
		tapsCount += 1
		collectionView.reloadData()
		if tapsCount == 1 {
			counter.invalidate()
			start = Date()
			counter = Timer.scheduledTimer(timeInterval: 1,
										   target: self,
										   selector: #selector(counterTick),
										   userInfo: nil,
										   repeats: true)
			skipButton?.isEnabled = false
		}
		if progress >= cellModels.count/2 {
			counter.invalidate()
			skipButton?.isEnabled = true
			let finish = Date()
			if 	let start = start,
			(Storage.currentHighscore?.duration ?? finish.timeIntervalSince(start)+1) > finish.timeIntervalSince(start)
			{
				let newDuration = finish.timeIntervalSince(start)
				Storage.currentHighscore = SessionRecord(duration: newDuration,
														 tapsCount: tapsCount)
				recordTimeLabel.text = "Highscore: \(timeFormatter.string(from: newDuration))"
				recordCounterLabel.text = "Taps: \(tapsCount)"
			}
		}
	}
	
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MatchesCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenSize = UIScreen.main.bounds.size
		let minSide = min(screenSize.width, screenSize.height)
		let cellsWide: CGFloat
		switch cellModels.count {
		case 1: cellsWide = 1
		case 2, 4: cellsWide = 2
		case 3, 5, 6, 9, 11, 12: cellsWide = 3
		default: cellsWide = 4
		}
		let side = minSide/cellsWide - 3
		return CGSize(width: side, height: side)
	}
	
}
