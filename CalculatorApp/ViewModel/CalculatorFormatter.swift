//
//  CalculatorFormatter.swift
//  CalculatorApp
//
//  Created by Jono Jono on 21/2/2023.
//

import Foundation
import SwiftUI



class CalculatorFormatter{
	@Published var currentValue: String = "0"
	@Published var displayValue: String = "0"
	@Published var calHistory: String = "0"
	@Published var historyButtonTapped = false
	@Published var operatorTapped = false
	var previousOperatorTitle: CalculatorButton?
	var firstValue: String = ""
	var secondValue: String = ""
	var isFirstValueInput = false
	var dataModel = CalculatorDataModel()
	var currentOperation: CurrentOperation?
	var state: CalculatorStates?
	
	
		//MARK: - getting user input
	func gettingUserInputs(calButton: CalculatorButton){
			// toggle min or plus here
		if calButton.title == .minToggle || calButton.title == .percent {
			toggleMinusAndToPercent(calButton: calButton)
		}
			// if zero and period is tapped then add period
		else if currentValue == "0" && calButton.title == .period {
			currentValue += calButton.title.rawValue
			displayValue = currentValue
		}
		// if the current value is 0 which is initial value, then remove the 0 and add the one that user inputted
		else if currentValue == "0"{
			currentValue =  calButton.title.rawValue
			displayValue =  calButton.title.rawValue
		}
		// add the minus even if the value is -0
		else if currentValue == "-0"{
			currentValue = "-"
			currentValue +=  calButton.title.rawValue
			displayValue = currentValue
		}
			// if period is hit check if it has period already
		else if calButton.title == .period {
			if !currentValue.contains("."){
				currentValue +=  calButton.title.rawValue
				displayValue = currentValue
				
			}
		}
		else{
			// anything else assign the user input to the current and display value
			currentValue +=  calButton.title.rawValue
			displayValue = currentValue
			if let toDouble = Double(currentValue){
					// check if it is thousand to add comma
					let thousandChecked = toDouble.thousandFormat
					displayValue = thousandChecked
				
			}

		}

	}
	
	
	func addCommas(to number: Double) -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.groupingSeparator = ","
		numberFormatter.maximumFractionDigits = 2
		
		let million = 1000000.0
		let billion = 1000000000.0
		let trillion = 1000000000000.0
		
		if number >= trillion {
			numberFormatter.maximumFractionDigits = 0
			return numberFormatter.string(from: NSNumber(value: number / trillion))!
		} else if number >= billion {
			return numberFormatter.string(from: NSNumber(value: number / billion))!
		} else if number >= million {
			return numberFormatter.string(from: NSNumber(value: number / million))!
		} else {
			return numberFormatter.string(from: NSNumber(value: number))!
		}
	}

	
		//MARK: - Toggle between min or plus and change to percentage
	func toggleMinusAndToPercent(calButton: CalculatorButton){
			// changing/ toggle it before calculation
		var minOrPlus: Double = 0
		var result: String = ""
		// if state is completed or initial, minus and percent button should behave like normal
		if state == .completed || state == .initialState{
			if let displayVal = Double(displayValue){
				if calButton.title == .minToggle{
					minOrPlus = displayVal * -1
				}
				else if calButton.title == .percent{
					minOrPlus = displayVal / 100
					
				}
				
			}
		}
		// but if have operator selected
		else if state == .operatorSelected {
			if let firstVal = Double(firstValue){
				if calButton.title == .minToggle{
					// if when operator is selected but then user pressed minus toggle, it will turn it to -0 first and then allow user to input their value
					if let current = Double(currentValue){
						
						minOrPlus = current * -1
					}
				}
				else if calButton.title == .percent{
					// while if if percent pressed, it will grab the prev value * display value and / 100
					minOrPlus = firstVal * (Double(displayValue) ?? 0) / 100
					
				}
				
			}
		}
		// truncate if needed
		truncateOrZeroValue(with: minOrPlus, result: &result)
		
		
	}
	
	//MARK: - truncate the value of min/percent based on the result
	func truncateOrZeroValue(with value: Double, result: inout String){
			// if the inout value is 0 and user change it to min, this will allow it
		if value == -0.0{
			let toInt = Int(value)
			currentValue = String("-\(toInt)")
			displayValue = currentValue
		
			
		}
		
		else{
			result = value.truncated
			currentValue = result
			displayValue = currentValue
			
		}
	}
	
	//MARK: - formatting the history panel
	// this func will be check when first value is entered and getting the second value to prevent same operator being added to the cal history
	
	func calculatorOperatorButtonHistoryFormat(calButton: CalculatorButton){
		// getting the last 3 values of the calhistory since i added spaces on both sides of it
		let char = String(calHistory.suffix(2))
			// if button is equal and is not already in calHistory
		if state == .completed{
				// this somehow needs to be done or else the equal button will still present in calHistory
			let hisSuffix = String(calHistory.suffix(calHistory.count))
			if !hisSuffix.contains("="){
					// if not yet to be found in calHistory then add to it along with calculated value
				calHistory += String(" \(calButton.title.rawValue) ")
				calHistory += displayValue
			}else {
				return
				
			}
			
		}
		// check if it is operator button not equal button
		else if calButton.title != .equal {
			// if calhistory/char contains any of these operator buttons then i go check if they are more then 3 and not a number cuz i do not wanna remove numb such as -3 to be removed
			if char.contains("+") || char.contains("-") || char.contains("÷") || char.contains("x") {
				if calHistory.count > 3 && (Double(char) == nil){
					calHistory.removeLast(3)
				}
			}
			// add the button to it if they pass the check
			calHistory += " \(calButton.title.rawValue) "
			
			// but if the char has the the value minus(-) but can be converted into double, we go ahead and add button to calHistory
		}else if(Double(char) != nil){
			calHistory += " \(calButton.title.rawValue) "

		}
	}
	
	//MARK: - Clear display and reset to initial state
	// emptying all panels and reset
	func deleteValue(){
		currentValue = "0"
		displayValue = "0"
		calHistory = ""
		firstValue = ""
		secondValue = ""
		currentOperation = .none
		state = .initialState
		isFirstValueInput = false
		
	}
	//MARK: - delete each char in the string when swipe right of left
	func deleteGesture(){
		if !displayValue.isEmpty && displayValue.count != 1{
			
				// remove one of the value when it is not empty and not just 1 digit
			displayValue.removeLast()
			currentValue = displayValue

				// convert string display to int while removing the comma
			if let displayToInt = Int(displayValue.removeComma) {
				// this will remove the comma if it is less than 1k
				if displayToInt < 1000 {
					
					displayValue = String(displayToInt)
					currentValue = displayValue

				//currentValue = displayValue
				// anything less than a billion i wanna recheck if more than 1k i wanna add the comma back on
				}else if displayToInt < 1000_000_000{
					let displayToDouble = Double(displayToInt)
					displayValue = displayToDouble.thousandFormat
					currentValue = displayValue

				}
			}
		}else if displayValue.count == 1{
			
			displayValue.removeLast()
			displayValue = "0"
			currentValue = displayValue
			
		}
	}
	// these dict determine/map the Colour of each calc button
	@Published var buttonColors = ["AC": Color.redAccentColor.opacity(0.8),
						"+/-": Color.minAndPercentColor.opacity(0.6),
						"%": Color.minAndPercentColor.opacity(0.6),
						"÷": Color.yellowAccentColor,
						"x": Color.yellowAccentColor ,
						"-": Color.yellowAccentColor ,
						"+": Color.yellowAccentColor ,
						"=": Color.equalColor ,
						"selected": Color.blue // add a separate color for selected buttons

	]
	
	//MARK: - This func will change the colour of the operators based on what tapped and revert when other button is tapped
	func alterColor(calButton: CalculatorButton){
			// Check if an operator button was previously tapped
		if operatorTapped {
				// If so, revert the color of the previously tapped operator button to yellow
			if let prevOpTitle = previousOperatorTitle {
				buttonColors[prevOpTitle.title.rawValue] = .yellowAccentColor
			}
			
				// Check if the current button is an operator button
			if let color = buttonColors[calButton.title.rawValue] {
					// If so, change the color of the current button to a slightly opaque version of its original color
				buttonColors[calButton.title.rawValue] = color.opacity(0.5)
				previousOperatorTitle = calButton
			} else {
					// If not, change the current button to its original color
				buttonColors[calButton.title.rawValue] = .yellowAccentColor
			}
			
				// Reset the operatorTapped flag
			operatorTapped = false
		}
		else {
			//This block is executed if the current button is not an operator button. It simply sets the colour of the prev operator button to yellow
			if let prevOpTitle = previousOperatorTitle {
				buttonColors[prevOpTitle.title.rawValue] = .yellowAccentColor
				previousOperatorTitle = nil
			}
		}
		
	}


	


	
	
}



