//
//  CalculatorHistoryRealm.swift
//  CalculatorApp
//
//  Created by Jono Jono on 27/2/2023.
//

import Foundation
import RealmSwift


class CalculatorHistoryRealm: Object, Identifiable{
	@Persisted var id = UUID()
	@Persisted var calHistory: String = ""
}
