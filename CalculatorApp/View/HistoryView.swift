//
//  HistoryView.swift
//  CalculatorApp
//
//  Created by Jono Jono on 24/2/2023.
//

import SwiftUI
import RealmSwift


struct HistoryPopOver: View {
	var vm: CalculatorLogicVM
	var body: some View {
		VStack{
			List{
				ForEach(vm.historyCal.reversed()) { calHistory in
					Text(calHistory.calHistory)
						.font(.caption)
						.listRowBackground(Color.backgroundColor)
					
					
				}
				.onDelete { indexSet in
					vm.deleteHistory(indexSet: indexSet)
				}
				
			}
			.listStyle(.inset)
			.cornerRadius(10)
			
		}
		.padding()
		.frame(width: 300, height: 500)
		.transition(.move(edge: .trailing))
		
		
	}
		
}


struct PopoverView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryPopOver(vm: CalculatorLogicVM())
		
	}
}
