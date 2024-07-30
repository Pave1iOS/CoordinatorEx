//
//  NavigatorView.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 30.07.2024.
//

import SwiftUI

protocol INavigatorView: ObservableObject {
	var navigator: (any ICoordinator)? { get set }
	func send(_ action: ActionView)
}

extension INavigatorView {
	func navigate(_ action: ActionType) {
		guard let navigator else { return }
		navigate(action)
	}
}

struct NavigatorView <ViewModel: INavigatorView>: ViewModifier {
	var navigator: (any ICoordinator)?
	
	@ObservedObject private var viewModel: ViewModel
	@StateObject private var coordinator = Coordinator()
	
	private let baseHeight: CGFloat = 40
	private let imageHeight: CGFloat = 15
	
	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}
	
	func body(content: Content) -> some View {
		willAppear(content: content)
	}
	
	@ViewBuilder
	func willAppear(content: Content) -> some View {
		let contentAdjust = adjust(content: content)
		
		switch coordinator.navigatorType {
		case .root:
			<#code#>
		case .sheet(let sceneType):
			<#code#>
		case .tab:
			<#code#>
		}
	}
	
	func adjust(content: Content) -> some View {
		content
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.ignoresSafeArea()
	}

	@ViewBuilder
	func embed(content: some View, withNavStack: Bool) -> some View {
		if withNavStack {
			NavigationStack(path: $coordinator.path) {
				switch coordinator.navigatorType {
				case .root:
					content
						.navigationDestination(for: Scenes.self) { page in
							coordinator.assembly(scene: .page(page))
						}
				case .sheet(let secondary):
					let height: CGFloat = switch secondary {
					case .page:
						0
					case .sheet:
						45
					case .cover:
						40
					}
				case .tab:
					<#code#>
				}
			}
		}
	}
	
	func addToolBar(content: some View, height: CGFloat) -> some View {
		content
			.overlay(alignment: .top) {
				toolBar(height: height)
					.ignoresSafeArea()
			}
	}
	
	func toolBar(height: CGFloat) -> some View {
		Color.white
			.background(Material.thin)
			.overlay(alignment: .bottom) {
				ZStack {
					HStack {
						Button {
							switch coordinator.navigatorType {
							case .root, .tab:
								return
							case .sheet(let secondary):
								<#code#>
							}
						} label: {
							
						}
					}
				}
			}
	}

	
	
	
	
	/// Отработка нажатия
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

extension View {
	
}
