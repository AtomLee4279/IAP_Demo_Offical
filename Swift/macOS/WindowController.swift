/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Primary window controller. Checks whether the user is allowed to make purchases and whether the resource file containing the product identifiers
exists. Disables the UI when the user is not allowed to make any purchases.
*/

import Cocoa

class WindowController: NSWindowController, NSUserInterfaceValidations {
	// MARK: - Properties

	fileprivate var resourceFile = ProductIdentifiers()
	fileprivate var mainViewController: MainViewController!

	// MARK: - Window Life Cycle

	override func windowDidLoad() {
		super.windowDidLoad()

		guard let window = window else { fatalError("\(Messages.windowDoesNotExist)") }
		guard let viewController = window.contentViewController as? MainViewController else { fatalError("\(Messages.viewControllerDoesNotExist)") }

		mainViewController = viewController

		// First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
		if StoreObserver.shared.isAuthorizedForPayments {
			// Refresh the UI if the resource file containing the product identifiers exists. Show a message, otherwise.
			guard let identifiers = resourceFile.identifiers else {
				// Warn the user that the resource file could not be found.
				mainViewController.reloadViewController(.messages, with: "\(resourceFile.wasNotFound)")
				return
			}

			// Refresh the UI if the resource file containing the product identifiers exists. Show a message, otherwise.
			if !identifiers.isEmpty {
				mainViewController.reloadViewController(.products)
			} else {
				// Warn the user that the resource file does not contain anything.
				mainViewController.reloadViewController(.messages, with: "\(resourceFile.isEmpty)")
			}
		} else {
			// Warn the user that they are not allowed to make purchases.
			mainViewController.reloadViewController(.messages, with: Messages.cannotMakePayments)
		}
	}

	// MARK: - Switches Between Products and Purchases Panes

	@IBAction fileprivate func showProducts(_ sender: NSToolbarItem) {
		guard ViewControllerNames(rawValue: sender.label) != nil else { fatalError("\(Messages.unknownToolbarItem)\(sender.label).") }
		mainViewController.reloadViewController(.products)
	}

	@IBAction func showPurchases(_ sender: NSToolbarItem) {
		guard ViewControllerNames(rawValue: sender.label) != nil else { fatalError("\(Messages.unknownToolbarItem)\(sender.label).") }
		mainViewController.reloadViewController(.purchases)
	}

	// MARK: - NSUserInterfaceValidations

	func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
		let identifiers = resourceFile.identifiers

		if item.action == #selector(WindowController.showProducts(_:)) {
			return StoreObserver.shared.isAuthorizedForPayments && (identifiers != nil && !(identifiers!.isEmpty))
		} else if item.action == #selector(WindowController.showPurchases(_:)) {
			return StoreObserver.shared.isAuthorizedForPayments
		}
		return false
	}
}
