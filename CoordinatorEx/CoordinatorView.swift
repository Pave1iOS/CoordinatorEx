//
//  CoordinatorView.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 26.07.2024.
//

import SwiftUI

struct CoordinatorView: View {
	
	var viewModel: ViewModel
	
	init(initType: CoordinatorInitType) {
		self.viewModel = .init(initType: initType)
	}
	
	var body: some View {
		ZStack {
			navigation()
		}
	}
	
	func navigation() -> some View {
		framing()
			.navigator(viewModel: viewModel)
	}
	
	func framing() -> some View {
		Color.blue.opacity(0.5)
			.overlay(content())
	}
	
//	@ViewBuilder
	func content() -> some View {
		List {
			Button(action: { viewModel.send(.buttonTapped(.page, .red)) }, label: { Text("RED") })
			Button(action: { viewModel.send(.buttonTapped(.sheet, .red)) }, label: { Text("RED SHEET") })
			Button(action: { viewModel.send(.buttonTapped(.cover, .red)) }, label: { Text("RED COVER") })
			
			Button(action: {  }, label: { Text("GREEN") })
			Button(action: {  }, label: { Text("GREEN SHEET") })
			Button(action: {  }, label: { Text("GREEN COVER") })
			
			Button(action: {  }, label: { Text("BLUE") })
			Button(action: {  }, label: { Text("BLUE SHEET") })
			Button(action: {  }, label: { Text("BLUE COVER") })
		}
		.navigationTitle(Text("Coordinator"))
	}
}

#Preview {
	CoordinatorView(initType: .root)
}
// MARK: - View для отображения
struct RedScene: View {
		
	var body: some View {
		ZStack {
			Color(.red)
				.ignoresSafeArea()
			VStack {
				Text("RedScene")
			}
		}
	}
}

struct GreenScene: View {
		
	var body: some View {
		ZStack {
			Color(.green)
				.ignoresSafeArea()
			VStack {
				Text("GreenScene")
			}
		}
	}
}

struct BlueScene: View {
		
	var body: some View {
		ZStack {
			Color(.blue)
				.ignoresSafeArea()
			VStack {
				Text("BlueScene")
			}
		}
	}
}
