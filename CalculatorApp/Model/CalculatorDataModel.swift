//
//  CalculatorDataModel.swift
//  CalculatorApp
//
//  Created by Jono Jono on 18/2/2023.
//

import Foundation
import SwiftUI

struct CalculatorDataModel{
	// throw each button into an array of buttons
	let calculatorButtons: [CalculatorButton] = [
		CalculatorButton(title: .allClear),
		CalculatorButton(title: .minToggle),
		CalculatorButton(title: .percent),
		CalculatorButton(title: .division),
		
		CalculatorButton(title: .seven),
		CalculatorButton(title: .eight),
		CalculatorButton(title: .nine),
		CalculatorButton(title: .multiplication),
		
		
		CalculatorButton(title: .four),
		CalculatorButton(title: .five),
		CalculatorButton(title: .six),
		CalculatorButton(title: .subtraction),
		
		CalculatorButton(title: .one),
		CalculatorButton(title: .two),
		CalculatorButton(title: .three),
		CalculatorButton(title: .addition),
		
		
		CalculatorButton(title: .zero),
		CalculatorButton(title: .period),
		CalculatorButton(title: .equal),
	]
	
	// columns that will be use for lazyVstack that has 4 items in which defined how many columns the lazyVStack will have
	let columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]

}

struct CalculatorButton: Hashable {
	// making a button from the enum
	let title: CalculatorButtonTitle
}
// each string value as the enum raw value which is strings
enum CalculatorButtonTitle: String {
	case allClear = "AC"
	case minToggle = "+/-"
	case percent = "%"
	case division =  "÷"
	
	case seven = "7"
	case eight = "8"
	case nine = "9"
	case multiplication = "x"
	
	case four = "4"
	case five = "5"
	case six = "6"
	case subtraction = "-"

	case one = "1"
	case two = "2"
	case three = "3"
	case addition = "+"
	
	case zero = "0"
	case period = "."
	case equal = "="
}
