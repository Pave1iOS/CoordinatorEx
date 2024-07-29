//
//  CoordinatorView.swift
//  CoordinatorEx
//
//  Created by Pavel Gribachev on 26.07.2024.
//

import SwiftUI

struct CoordinatorView: View {
	
	var coordinator = Coordinator()
	
	var body: some View {
		ZStack {
			generate()
		}
	}
	
	@ViewBuilder
	func generate() -> some View {
		List {
			Button(action: {  }, label: { Text("RED") })
			
			Button(action: {
				NavigationView {
					NavigationLink("") {
						
						coordinator.redFlow(.sheet)
					}
					
				}
				
			}, label: { Text("RED SHEET") })
			
			Button(action: {  }, label: { Text("RED COVER") })
			
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

//NavigationView {
	//			VStack {
	//				NavigationLink(destination: SheetView(), label: {
	//					Button(action: {
	//						showSheet.toggle()
	//					}, label: {
	//						Text("sheet")
	//					})
	//				}).sheet(isPresented: $showSheet, content: {
	//					SheetView()
	//				})
	//
	//				NavigationLink("fullScreen", destination: FullScreenView())
	//					.fullScreenCover(isPresented: $showCover, content: {
	//						FullScreenView()
	//					})
	//
	//				Button(action: {
	//					showAlert.toggle()
	//				}, label: {
	//					Text("show alert")
	//				}).alert(isPresented: $showAlert) {
	//					Alert(
	//						title: Text("Заголовок"),
	//						message: Text("Сообщение"),
	//						primaryButton: .default(Text("Хорошо"), action: {
	//							// Действие при нажатии на кнопку "Хорошо"
	//						}),
	//						secondaryButton: .cancel(Text("Отменить"), action: {
	//							// Действие при нажатии на кнопку "Отменить"
	//						})
	//					)
	//				}
	//
	//			}
	//		}
	//	}
