	//
	//  RealmLogic.swift
	//  CalculatorApp
	//
	//  Created by Jono Jono on 27/2/2023.
	//

import Foundation
import RealmSwift


class RealmLogic: CalculatorFormatter{
	// declare realm
	var realm: Realm!
	var historyCal: Results<CalculatorHistoryRealm>{
		getHistory()
	}
	
	override init() {
			// allowing the preview to be use along with realm cuz preview cannot access to file system so if not provided preview will crashed
		
#if DEBUG
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			print("Running in a preview context, skipping Realm initialization.")
			return
		}
#endif
		
		do {
			self.realm = try Realm()
				//			let defaultRealmURL = Realm.Configuration.defaultConfiguration.fileURL
				//			print(defaultRealmURL)
			
		} catch let error {
			print("Error initializing Realm: \(error.localizedDescription)")
		}
	}
		// add to realm
	func addHistory(){
		do {
			let calculatorHistory = CalculatorHistoryRealm()
			calculatorHistory.calHistory = calHistory
			
			try realm.write{
				realm.add(calculatorHistory)
				print("this is cal history from realm: \(calculatorHistory.calHistory)")
				
			}
		} catch  {
			print("error from realm: \(error.localizedDescription)")
		}
	}
	
	
	
		// fetch
	func getHistory() -> Results<CalculatorHistoryRealm> {

		return realm.objects(CalculatorHistoryRealm.self)
	}
	
	// delete from realm 
	func deleteHistory(indexSet: IndexSet){
		indexSet.forEach { index in
			let selectedToDelete = historyCal.reversed()[index]
			print(selectedToDelete)
			do {
				try realm.write {
					realm.delete(selectedToDelete)
				}
			} catch  {
				fatalError("Failed to delete Category from Realm")
			}
		}
	}
	
}
