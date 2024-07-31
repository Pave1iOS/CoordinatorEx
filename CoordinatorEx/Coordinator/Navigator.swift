//
//  Navigator.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 31.07.2024.
//

import SwiftUI

protocol ViewModelProtocol: ObservableObject {
	var coordinator: (any ICoordinator)? { get set }
	func send(_ action: ActionView)
}

final class ViewModel: ViewModelProtocol {
	@Published var coordinator: (any ICoordinator)?
	let coordinatorInitType: CoordinatorInitType
	
	init(initType: CoordinatorInitType) {
		coordinatorInitType = initType
	}
}

extension ViewModelProtocol {
	
	func navigate(_ action: ActionType) {
		guard (coordinator != nil) else { return }
		navigate(action)
	}
	
	func send(_ action: ActionView) {
		switch action {
			
		case .buttonTapped(let scene, let color):
			switch scene {
			case .page:
				switch color {
				case .red:
					navigate(.up(.page(.red)))
				case .green:
					navigate(.up(.page(.green)))
				case .blue:
					navigate(.up(.page(.blue)))
				}
			case .sheet:
				switch color {
				case .red:
					navigate(.up(.sheet(.red)))
				case .green:
					navigate(.up(.sheet(.green)))
				case .blue:
					navigate(.up(.sheet(.blue)))
				}
			case .cover:
				switch color {
				case .red:
					navigate(.up(.cover(.red)))
				case .green:
					navigate(.up(.cover(.green)))
				case .blue:
					navigate(.up(.cover(.blue)))
				}
			}
		}
	}
}

extension ViewModel {
	enum ActionType {
		case view(ActionViewType)
	}
}
