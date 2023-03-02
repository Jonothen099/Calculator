//
//  ResultPanelView.swift
//  CalculatorApp
//
//  Created by Jono Jono on 19/2/2023.
//

import SwiftUI
import RealmSwift
import UIKit

struct ResultPanelView: View {
	@State var dragAmount: CGFloat = 0
	@ObservedObject var vm: CalculatorLogicVM

	
	var body: some View {
		
		ZStack{
			VStack {
								
				HStack{
					Text("Calculator")
						.font(.largeTitle.bold())
						.frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
					Button {
						withAnimation(.easeIn) {
							vm.historyButtonTapped.toggle()
								
						}
					} label: {
						Image(systemName: "clock.arrow.circlepath")
							.resizable()
							.frame(width: 30, height: 25)
							.foregroundColor(.primary)
					}
					// adding custom popover since IOS doesn't have a popover like ipad
					.IOSPopover(isPresented: $vm.historyButtonTapped, arrowDirection: .any, content: {
						VStack{
							HStack{
								Button {
									vm.historyButtonTapped = false
								} label: {
									Image(systemName: "xmark.circle")
										.foregroundColor(.primary)
								}
								Spacer()
							}
							.padding(.bottom, -20)
							
							HistoryPopOver(vm: vm)
						}
						.background {
							Rectangle()
								.fill(Color.minAndPercentColor.gradient)
								.padding(-20)
							
							
							
						}
					})

				
					
				}
				.padding(.bottom, 10)
			
				
				
				VStack(alignment: .trailing){
					
					GeometryReader { geometry in
						Spacer()
						ScrollView(.horizontal) {
							Text(vm.calHistory)
								.font(.callout.bold()).opacity(0.7)
								.lineLimit(1)
								.frame(width: geometry.size.width - 40 , height: 40, alignment: .trailing)
								.frame(minHeight: 30)
								.allowsTightening(false)
						}
						.offset(y: 5)
						.foregroundColor(.primary)
						.padding(.bottom, 10)
						.background(Color.backgroundColor.opacity(0.6))
						.cornerRadius(15)
						.padding(10)
						.background(Color.backgroundColor.opacity(0.5))
						.cornerRadius(20)
					}
					
					Text(vm.displayValue)
						.font(.system(size: 40) .bold())
						.foregroundColor(.primary)
						.frame(alignment: .trailing)
						.allowsTightening(false)
						.minimumScaleFactor(0.4)
						.padding(.top, 20)
				}
				.frame(maxWidth: .infinity, maxHeight: 170, alignment: .bottomTrailing)
				.frame(minHeight: 80)
				.padding()
				.background(Color.resultPanelColor)
				.cornerRadius(30)
				.padding(.bottom, 20)
				.overlay {
					RoundedRectangle(cornerRadius: 30)
						.stroke(.black, lineWidth: 2)
						.blur(radius: 1)
				}
				.padding(.bottom, 10)
				.gesture(
					DragGesture()
						.onChanged({ value in
							dragAmount = value.predictedEndTranslation.width
						})
						.onEnded({ value in
							if dragAmount > 100 {
								vm.deleteGesture()
							} else if dragAmount < -100 {
								vm.deleteGesture()
								
							}
							dragAmount = 0
						})
				)
			}
		}
	}
}

struct ResultPanelView_Previews: PreviewProvider {
    static var previews: some View {
		ResultPanelView(vm: CalculatorLogicVM())
    }
}





