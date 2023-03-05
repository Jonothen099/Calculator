//
//  ButtonComponent.swift
//  CalculatorApp
//
//  Created by Jono Jono on 19/2/2023.
//

import SwiftUI

struct ButtonComponent: View {
	@ObservedObject var vm: CalculatorLogicVM
	var buttonTitle: CalculatorButton
	var minWidth: CGFloat? = 60
	var minHeight: CGFloat? = UIScreen.main.bounds.width > 380 ? 80 : 65
	var maxWidth: CGFloat? = 200
	var maxHeight: CGFloat? = 90
	var background: Color? = .numbColor
	func isNotNumb(button: String) -> Bool{
		// check if the button has the key value to the dictionary that holds colours
		if 	vm.buttonColors[button] != nil{
			return true
		} else{
			return false
		}
		
	}
	
	
	var body: some View {
		VStack {
			Button {
				switch buttonTitle.title{
					case .allClear:
						withAnimation(.easeIn) {
							vm.deleteValue()
							vm.alterColor(calButton: buttonTitle)
						}
					case .addition, .subtraction, .multiplication, .division:
							withAnimation(.easeOut){
								vm.getBothValues(calButton: buttonTitle)
								vm.operatorTapped.toggle()
								vm.alterColor(calButton: buttonTitle)
							}
					case .equal:
						withAnimation(.easeOut){
							vm.equalButtonTapped(calButton: buttonTitle)
							vm.alterColor(calButton: buttonTitle)

						}
					default:
						withAnimation(.easeOut) {
							vm.gettingUserInputs(calButton: buttonTitle)
							vm.alterColor(calButton: buttonTitle)
						}
						
				}
				// adding haptic feedback
				let impact = UIImpactFeedbackGenerator(style: .light)
				impact.impactOccurred()

//
			} label: {
				Text(buttonTitle.title.rawValue)
					.font(.title.bold())
					.frame(minWidth: minWidth, minHeight: minHeight)
					.frame(maxWidth: maxWidth, maxHeight: maxHeight)
					.background(isNotNumb(button: buttonTitle.title.rawValue) ? vm.buttonColors[buttonTitle.title.rawValue] : background)


					.foregroundColor(.primary)
					.cornerRadius(25)
				
				
			}
			.shadow(color: .black.opacity(0.7), radius: 3, x: -5, y: 5)
			.overlay {
				RoundedRectangle(cornerRadius: 40)
					.stroke(.black, lineWidth: 5)
					.blur(radius: 12)
			}

		}

	}
	
	
	
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
		ButtonComponent(vm: CalculatorLogicVM(), buttonTitle: CalculatorButton(title: .nine))
			
	}
}
