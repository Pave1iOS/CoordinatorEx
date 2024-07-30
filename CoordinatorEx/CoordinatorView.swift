//
//  CoordinatorView.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 26.07.2024.
//

import SwiftUI

struct CoordinatorView: View {
	
	var coordinator = Coordinator()
	var navigatorView = NavigatorView()
	
	var body: some View {
		ZStack {
			generate()
		}
	}
	
	@ViewBuilder
	func generate() -> some View {
		List {
			Button(action: { navigatorView.send(.buttonTapped(.page, .red)) }, label: { Text("RED") })
			Button(action: { navigatorView.send(.buttonTapped(.sheet, .red)) }, label: { Text("RED SHEET") })
			Button(action: { navigatorView.send(.buttonTapped(.cover, .red)) }, label: { Text("RED COVER") })
			
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
	CoordinatorView()
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
