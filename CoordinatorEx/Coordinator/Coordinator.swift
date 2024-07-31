//
//  Coordinator.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 26.07.2024.
//

import Foundation
import SwiftUI

/// Доступные экраны
enum Scenes: String, Identifiable {
	case red
	case green
	case blue
	
	var id: String { self.rawValue }
}

/// Тип навигации
enum NavigatorType: Equatable {
	
	enum SceneType {
		case page
		case sheet
		case cover
	}
	
	case root
	case sheet(SceneType)
	case tab
}

/// Переходы между Scene
enum ActionType {
	/// Виды переходов (на следующую Scene)
	enum SceneType {
		case cover(Scenes)
		case sheet(Scenes)
		case page(Scenes)
	}
	
	/// Виды возвратов (на предыдущую Scene или в начало)
	enum ReturnType {
		case pop
		case popToRoot
		case dismiss
	}
	
	/// Переход вверх на следующую Scene
	case up(SceneType)
	/// Переход вниз на предыдущую Scene или в root
	case down(ReturnType)
}

enum ActionView {
	enum Scenes {
		case page
		case sheet
		case cover
	}
	
	enum ColorType {
		case red
		case green
		case blue
	}
	
	case buttonTapped(Scenes, ColorType)
}

enum ActionViewType {
	case view(ActionView)
}

enum CoordinatorInitType {
	case root
	case tab(root: any ICoordinator)
	case sheet(navigationAction: ActionType.SceneType, root: any ICoordinator)
}

// MARK: - ICoordinator
protocol ICoordinator: ObservableObject {
	associatedtype SomeView: View
	
	var path: NavigationPath { get set }
	var root: (any ICoordinator)? { get set }
	var cover: Scenes? { get set }
	var sheet: Scenes? { get set }
	var navigatorType: NavigatorType { get set }
	var navigationRootStackType: NavigatorType? { get set }
	
	func navigate(_ action: ActionType)
	func assembly(scene type: ActionType.SceneType) -> SomeView
}

extension ICoordinator {
	func initialise(type: CoordinatorInitType) {
		switch type {
		case .root:
			navigatorType = .root
		case .tab(let root):
			navigatorType = .tab
			self.root = root
		case .sheet(let navigationAction, let root):
			switch navigationAction {
			case .page:
				navigatorType = .sheet(.page)
				guard let root = root.navigationRootStackType else {
					return navigationRootStackType = root.navigatorType
				}
				navigationRootStackType = root
			case .cover:
				navigatorType = .sheet(.cover)
			case .sheet:
				navigatorType = .sheet(.sheet)
			}
		}
	}
	
	func navigate(_ action: ActionType) {
		switch action {
		case .up(let sceneType): // создание новой сцены
			switch sceneType { // выбор типа сцены
			case .cover(let cover): // сцена во весь экран
				self.cover = cover
			case .sheet(let sheet): // сцена листа
				self.sheet = sheet
			case .page(let page): // сцена открытия новой страницы
				switch navigatorType { // список всех возможных страниц
				case .root: // главная сцена
					path.append(page)
				case .sheet(let secondary): // сцена листа
					switch secondary { // список сцен для листа
					case .page: // страница
						root?.navigate(.up(.page(page)))
					case .sheet, .cover: // лист и во весь экран
						path.append(page)
					}
				case .tab: // сцена из таббар
					root?.navigate(.up(.page(page)))
				}
			}
		case .down(let returnType): // возврат/удаление сцены
			switch returnType {
			case .pop: // возврат назад
				switch navigatorType { // список всех возможных страниц
				case .root: // главная сцена
					guard !path.isEmpty else { return }
					path.removeLast()
				case .sheet(let secondary): // лист
					switch secondary { // перечисление страниц в листе
					case .page: // страница
						root?.navigate(.down(.pop))
					case .sheet, .cover: // лист и во весь экран
						guard !path.isEmpty else { return }
						path.removeLast()
					}
				case .tab:
					break
				}
			case .popToRoot:
				break
			case .dismiss:
				root?.sheet = nil
				root?.cover = nil
			}
		}
	}
}

final class Coordinator: ICoordinator {
	
	@Published var path = NavigationPath()
	var root: (any ICoordinator)?
	var navigatorType: NavigatorType = .root
	var navigatorRoot: NavigatorType?
	var navigationRootStackType: NavigatorType?
	
	
	@State var cover: Scenes?
	@State var sheet: Scenes?
	
	init(initType: CoordinatorInitType) {
		initialise(type: initType)
	}
	
	/// Сборка модуля с экранами
	@ViewBuilder
	func assembly(scene type: ActionType.SceneType) -> some View {
		switch type {
		case .cover(let scenes), .sheet(let scenes), .page(let scenes):
			switch scenes {
			case .red:
				RedScene()
			case .green:
				GreenScene()
			case .blue:
				BlueScene()
			}
		}
	}
}
