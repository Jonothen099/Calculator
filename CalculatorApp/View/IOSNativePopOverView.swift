//
//  NativePopOverView.swift
//  CalculatorApp
//
//  Created by Jono Jono on 26/2/2023.
//

import SwiftUI

extension View{
	@ViewBuilder
	func IOSPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection, @ViewBuilder content: @escaping ()->Content)-> some View{
		self
			.background{
					PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
			}
	}
}

struct PopOverController<Content: View>: UIViewControllerRepresentable{
	
	
	@Binding var isPresented: Bool
	var arrowDirection: UIPopoverArrowDirection
	var content: Content
	@State private var presented: Bool = false
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
	func makeUIViewController(context: Context) -> some UIViewController {
		let controller = UIViewController()
		controller.view.backgroundColor = .clear
		return controller
	}
	
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		if presented{
			print(isPresented)
			if !isPresented{
				uiViewController.dismiss(animated:true)
				DispatchQueue.main.async {
					presented = false
				}
			}
		}else{
			if isPresented{
				let controller = CustomHostingView(rootView: content)
				controller.view.backgroundColor = .clear
				controller.modalPresentationStyle = .popover
				controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
				controller.presentationController?.delegate = context.coordinator
				controller.popoverPresentationController?.sourceView = uiViewController.view
				uiViewController.present(controller, animated: true)
			}
		}
		
	}
	
	
		// forcing it to show popover using presentation Delegate
	class Coordinator: NSObject, UIPopoverPresentationControllerDelegate{
		var parent: PopOverController
		init(parent: PopOverController) {
			self.parent = parent
		}
		func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
			return .none
		}
		func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
			parent.isPresented = false
		}
		func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
			DispatchQueue.main.async {
				self.parent.presented = true
			}
		}
		
	}
	
}

class CustomHostingView<Content: View>: UIHostingController<Content>{
	override func viewDidLoad() {
		super.viewDidLoad()
		preferredContentSize = view.intrinsicContentSize
	}
}

