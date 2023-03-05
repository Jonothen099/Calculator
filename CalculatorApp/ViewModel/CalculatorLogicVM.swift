//
//  CalculatorLogic.swift
//  CalculatorApp
//
//  Created by Jono Jono on 20/2/2023.
//

import Foundation
import RealmSwift


class CalculatorLogicVM: RealmLogic, ObservableObject{
	
		//MARK: - Getting first value and second value to perform calculation
	func getBothValues(calButton: CalculatorButton){
		if state == .completed{
			calHistory = "0"
		}
			// getting first value
		if !isFirstValueInput {
			state = .firstValueEntered
			
			firstValue = displayValue
			// preventing adding the initial 0 value by removing it first
			if calHistory == "0"{
				calHistory = ""
			}
			calHistory += firstValue
				// determine what operator button is pressed
			determineOperators(button: calButton)
			// empty current value so it can be repopulated
			currentValue = "0"
				//			userInputFormatter.currentValue = "0"
				//			userInputFormatter.displayValue = ""
			isFirstValueInput.toggle()
		}
			// if first value already there, then the user input will be second value and assign it accordingly
		else{
				// it is important to assign the first value from current value not display value
				// as the current value is cleared after first value is assigned and calculation, but display value stayed
				// so if you click/change to other than the previous calc operator, it will assign display value to second value where we wanted to change operator and then allow user to input value for the second value
			state = .secondValueEntered
//			secondValue = currentValue
			secondValue = currentValue
			// preventing adding the initial 0 value by removing it first
			if calHistory == "0"{
				calHistory = ""
			}
			if let secondToDouble = Double(secondValue){
				
				calHistory += secondToDouble.thousandFormat
			}

		}
		
		
		// perform calculation when both values are assigned
		performCalculation(calButton: calButton)
	}
	
	//MARK: - SubFunc determine what kind of operator is selected
	func determineOperators(button: CalculatorButton){
		switch button.title{
			case .addition:
				currentOperation = .addition
			case .subtraction:
				currentOperation = .subtraction
			case .multiplication:
				currentOperation = .multiplication
			case .division:
				currentOperation = .division
			case .equal:
				currentOperation = .equal
			default:
				break
		}
		state = .operatorSelected
		
	}
		//MARK: - Perform Calculation after the values are assigned accordingly
	func performCalculation(calButton: CalculatorButton) {
		// perform calculation
		calculate()
		firstValue = displayValue
		// determine operators button for the next calculation
		determineOperators(button: calButton)
		// format history of calculation
		calculatorOperatorButtonHistoryFormat(calButton: calButton)
		// empty some value when calculation is done, so when next value is entered we can perform next calculation
		// this here only for none = button tho
		currentValue = ""
		secondValue = ""
	}
	
	//MARK: - calculate the values based on the operator selected
	func calculate() {
		guard let first = Double(firstValue.removeComma), let second = Double(secondValue.removeComma) else {return}
		var result: Double = 0
		if let operation = currentOperation {
			switch operation {
				case .addition:
					result = first + second
					
				case .subtraction:
					result = first - second
					
				case .multiplication:
					result = first * second
					
				case .division:
					result = first / second
				default: break
					
			}
		}
		// determine it is thousand or not and truncate if needed
		let thousandFormatted = result.thousandFormat
		displayValue = thousandFormatted
	}
	
	
	
	
	
	//MARK: - If Equal button is tapped
	func equalButtonTapped(calButton: CalculatorButton) {
		// when equal button is tapped i still have to assign the current value that user enter as second value and as the history value too
		secondValue = currentValue
		if let secondToDouble = Double(secondValue){
			// check for thousand or
			calHistory += secondToDouble.thousandFormat
		}
		// then perform calculation here
		calculate()
		// when done empty the current value
		currentValue = ""

		state = .completed
		calculatorOperatorButtonHistoryFormat(calButton: calButton)
		// add the history to realm
		addHistory()
		// set operation to none if = button is pressed
		currentOperation = .none
		// also empty the second value
		secondValue = ""
		// change the calculator state to completed state
		isFirstValueInput.toggle()

	}
	

	
}

