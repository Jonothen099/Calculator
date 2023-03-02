//
//  CalculatorStates.swift
//  CalculatorApp
//
//  Created by Jono Jono on 19/2/2023.
//

import Foundation

// this enum will keeps track of the calculator state
enum CalculatorStates: Equatable {
	case initialState
	case firstValueEntered
	case operatorSelected
	case secondValueEntered
	case completed
	
}
