//
//  NavigatorView.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 30.07.2024.
//

import SwiftUI

protocol INavigatorView: ObservableObject {
	var coordinator: (any ICoordinator)? { get set }
	func send(_ action: ActionView)
}

extension INavigatorView {
	func navigate(_ action: ActionType) {
		guard (coordinator != nil) else { return }
		navigate(action)
	}
}

struct NavigatorView <ViewModel: INavigatorView>: ViewModifier {
	var navigator: (any ICoordinator)?
	
	@ObservedObject private var viewModel: ViewModel
	@StateObject private var coordinator: Coordinator
	
	private let baseHeight: CGFloat = 40
	private let imageHeight: CGFloat = 15
	
	init(viewModel: ViewModel) {
		self.viewModel = viewModel
		self.coordinator = .init(initType: viewModel.coordinatorInitType)
	}
	
	func body(content: Content) -> some View {
		willAppear(content: content)
	}
	
	@ViewBuilder
	func willAppear(content: Content) -> some View {
		let contentAdjust = adjust(content: content)
		
		switch coordinator.navigatorType {
		case .root:
			embed(content: contentAdjust, withNavStack: true)
		case .sheet(let secondary):
			switch secondary {
			case .page:
				embed(content: contentAdjust, withNavStack: false)
			case .cover, .sheet:
				embed(content: contentAdjust, withNavStack: true)
			}
		case .tab:
			embed(content: contentAdjust, withNavStack: false)
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
					
					addToolBar(content: content, height: height)
						.navigationDestination(for: Scenes.self) { page in
							coordinator.assembly(scene: .page(page))
						}
				case .tab:
					Text("Error")
				}
			}
			.sheet(item: $coordinator.sheet) { sheet in
				coordinator.assembly(scene: .sheet(sheet))
			}
			.fullScreenCover(item: $coordinator.cover) { cover in
				coordinator.assembly(scene: .cover(cover))
			}
		} else {
			ZStack {
				switch coordinator.navigatorType {
				case .root:
					Text("Error")
				case .sheet(let secondary):
					switch secondary {
					case .page:
						let height = if let rootType = coordinator.navigatorRoot, rootType == .sheet(.sheet) {
							baseHeight
						} else {
							50.0
						}
						addToolBar(content: content, height: height)
					case .sheet, .cover:
						Text("Error")
					}
				case .tab:
					content
				}
			}
			.sheet(item: $coordinator.sheet) { sheet in
				coordinator.assembly(scene: .sheet(sheet))
			}
			.fullScreenCover(item: $coordinator.cover) { cover in
				coordinator.assembly(scene: .cover(cover))
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
								switch secondary {
								case .page:
									coordinator.navigate(.down(.pop))
								case .sheet, .cover:
									coordinator.path.isEmpty
									? coordinator.navigate(.down(.dismiss))
									: coordinator.navigate(.down(.pop))
								}
							}
						} label: {
							let image = switch coordinator.navigatorType {
								
							case .root, .tab:
								Image(systemName: "chevron.left")
							case .sheet(let secondary):
								switch secondary {
								case .page:
									Image(systemName: "chevron.left")
								case .cover, .sheet:
									coordinator.path.isEmpty
									? Image(systemName: "xmark")
									: Image(systemName: "chevron.left")
								}
							
							}
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: imageHeight, height: imageHeight)
						}
						Spacer()
					}
					.padding(.horizontal, 15)
				}
				.frame(height: baseHeight)
			}
			.overlay(alignment: .bottom) {
				Color(.gray)
					.frame(height: 1)
			}
			.frame(height: height)
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
	func navigator<ViewModel: ViewModelProtocol>(viewModel: ViewModel) -> some View {
		self.modifier(NavigatorView(viewModel: viewModel))
	}
}
