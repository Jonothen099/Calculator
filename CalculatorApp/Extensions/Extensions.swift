//
//  Extensions.swift
//  CalculatorApp
//
//  Created by Jono Jono on 18/2/2023.
//

import Foundation
import SwiftUI

extension Double {
	var truncated: String {
		if self.truncatingRemainder(dividingBy: 1) == 0 {
			let makeInt = Int(self)
			return String(makeInt)
		} else {
			return String(self)
		}
	}
	
		// add comma for thousands
	var thousandFormat: String {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = ","
		formatter.numberStyle = .decimal
		let formattedString = formatter.string(from: self as NSNumber) ?? String(self)
		return formattedString
	}
	
}

extension String {
//		 remove comma so that i can use it for arrhythmic calculation
	var removeComma: String {
		let numbWithoutComma = self.replacingOccurrences(of: ",", with: "")
		return numbWithoutComma
	}
}



extension Color {
	
	static let backgroundColor = Color("bGColor")
	static let equalColor = Color("equalColor")
	static let numbColor = Color("numbColor")
	static let redAccentColor = Color("redAccentColor")
	static let yellowAccentColor = Color("yellowAccentColor")
	static let minAndPercentColor = Color("minAndPercentColor")
	static let resultPanelColor = Color("resultPanelColor")
	
	
}




