	//
	//  SecondCalculatorView.swift
	//  CalculatorApp
	//
	//  Created by Jono Jono on 18/2/2023.
	//

import SwiftUI

struct CalculatorView: View {
	@ObservedObject var vm = CalculatorLogicVM()
	
	
	
	var body: some View {
		
		ZStack {
			Color.backgroundColor.opacity(0.95).ignoresSafeArea()
			
			VStack{
				
				ResultPanelView(vm: vm)
				// using lazyVStack with 4 columns
				LazyVGrid(columns: vm.dataModel.columns) {
					// populating the lazyVStack
					ForEach(vm.dataModel.calculatorButtons, id: \.self) { button in
						HStack{
							// setting up different colour and sizes for different type of button
							// this possible cuz vm.dataModel.calculatorButtons is created sequentially like how the calculator view should be
							switch button.title {
								case  .zero:
									GeometryReader { geometry in
										ButtonComponent(vm: vm, buttonTitle: button)
											.frame(
												width: geometry.size.width * 2.1)
									}
								case  .equal:
									GeometryReader { geometry in
										ButtonComponent(vm: vm, buttonTitle: button)
											.frame(width: geometry.size.width * 1)
											.padding(.leading, geometry.size.width * 1.1)
									}
								case .period:
									GeometryReader { geometry in
										ButtonComponent(vm: vm, buttonTitle: button)
											.frame(width: geometry.size.width * 1)
											.padding(.leading, geometry.size.width * 1.1)
									}
								default:
									ButtonComponent(vm: vm, buttonTitle: button)
							}
							
						}
						
					}
				}
				
			}
			.frame(maxWidth: .infinity)
			.padding(20)
			// having dynamic padding for different iPhone sizes
			.padding(.bottom, UIScreen.main.bounds.height > 670 ? 30 : 60)
			.onAppear{
				vm.state = .initialState
			}
		}
			// declaring this will allow history view to be on top of this view when i need to view the history view
		.zIndex(0)
			// dismiss history view
		.onTapGesture {
			vm.historyButtonTapped = false
		}
	}
}

struct CalculatorView_Previews: PreviewProvider {
	static var previews: some View {
		CalculatorView()
	}
}
