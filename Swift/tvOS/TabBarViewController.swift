/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Tab bar view controller that manages the Products, Purchases, and Settings view controllers. Requests product information about a list of product
identifiers using StoreManager. Listens and handles purchase and restore notifications.
*/

import UIKit
import StoreKit

class TabBarViewController: UITabBarController {
	// MARK: - Types

	enum TabBarViewControllerItems: Int {
		case products, purchases, settings
	}

	// MARK: - Properties

	fileprivate var utility = Utilities()
	fileprivate var resourceFile = ProductIdentifiers()
	fileprivate var restoreWasCalled = false

	fileprivate lazy var products: Products = {
		guard let navigation = self.viewControllers?[TabBarViewControllerItems.products.rawValue] as? UINavigationController
			else { fatalError("\(Messages.unableToInstantiateNavigationController)") }

		guard let controller = navigation.topViewController as? Products else { fatalError("\(Messages.unableToInstantiateProducts)") }
		return controller
	}()

	fileprivate lazy var purchases: Purchases = {
		guard let navigation = self.viewControllers?[TabBarViewControllerItems.purchases.rawValue] as? UINavigationController
			else { fatalError("\(Messages.unableToInstantiateNavigationController)") }

		guard let controller = navigation.topViewController as? Purchases else { fatalError("\(Messages.unableToInstantiatePurchases)") }
		return controller
	}()

	fileprivate lazy var settings: Settings = {
		guard let navigation = self.viewControllers?[TabBarViewControllerItems.settings.rawValue] as? UINavigationController
			else { fatalError("\(Messages.unableToInstantiateNavigationController)") }

		guard let controller = navigation.topViewController as? Settings else { fatalError("\(Messages.unableToInstantiateSettings)") }
		return controller
	}()

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self

		StoreManager.shared.delegate = self
		StoreObserver.shared.delegate = self
		settings.delegate = self
	}

	// MARK: - Fetch Product Information

	/// Retrieves product information from the App Store.
	fileprivate func fetchProductInformation() {
		// First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
		if StoreObserver.shared.isAuthorizedForPayments {
			let resourceFile = ProductIdentifiers()

			guard let identifiers = resourceFile.identifiers else {
				// Warn the user that the resource file could not be found.
				alert(with: Messages.status, message: resourceFile.wasNotFound)
				return
			}

			if !identifiers.isEmpty {
				// Refresh the UI with identifiers to be queried.
				products.reload(with: [Section(type: .invalidProductIdentifiers, elements: identifiers)])

				// Fetch the product information.
				StoreManager.shared.startProductRequest(with: identifiers)
			} else {
				// Warn the user that the resource file does not contain anything.
				alert(with: Messages.status, message: resourceFile.isEmpty)
			}
		} else {
			// Warn the user that they are not allowed to make purchases.
			alert(with: Messages.status, message: Messages.cannotMakePayments)
		}
	}

	// MARK: - Handle Restored Transactions

	/// Handles succesful restored transactions. Switches to the Purchases tab.
	fileprivate func handleRestoredSucceededTransaction() {
		utility.restoreWasCalled = restoreWasCalled
		purchases.reload(with: utility.dataSourceForPurchasesUI)
		selectedIndex = 1
	}

	// MARK: - Display Alert

	/// Creates and displays an alert.
	func alert(with title: String, message: String) {
		let alertController = utility.alert(title, message: message)
		self.present(alertController, animated: true, completion: nil)
	}
}

// MARK: - UITabBarControllerDelegate

/// Extends TabBarViewController to conform to UITabBarControllerDelegate.
extension TabBarViewController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		return StoreObserver.shared.isAuthorizedForPayments
	}

	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		guard let index = tabBarController.viewControllers?.index(of: viewController) else { fatalError("\(Messages.unknownSelectedViewController)") }

		guard let item = TabBarViewControllerItems(rawValue: index) else { fatalError("\(Messages.unknownTabBarIndex)\(index)).") }

		switch item {
		case .products:
			restoreWasCalled = false
			fetchProductInformation()
		case .purchases:
			if let controller = (viewController as? UINavigationController)?.topViewController as? Purchases {
				utility.restoreWasCalled = restoreWasCalled
				controller.reload(with: utility.dataSourceForPurchasesUI)
			}
		case .settings: restoreWasCalled = false
		}
	}
}

// MARK: - SettingsDelegate

/// Extends TabBarViewController to conform to SettingsDelegate.
extension TabBarViewController: SettingsDelegate {
	func settingDidSelectRestore() {
		restoreWasCalled = true
	}
}

// MARK: - StoreManagerDelegate

/// Extends TabBarViewController to conform to StoreManagerDelegate.
extension TabBarViewController: StoreManagerDelegate {
	func storeManagerDidReceiveResponse(_ response: [Section]) {
		products.reload(with: response)
	}

	func storeManagerDidReceiveMessage(_ message: String) {
		alert(with: Messages.productRequestStatus, message: message)
	}
}

// MARK: - StoreObserverDelegate

/// Extends TabBarViewController to conform to StoreObserverDelegate.
extension TabBarViewController: StoreObserverDelegate {
	func storeObserverDidReceiveMessage(_ message: String) {
		alert(with: Messages.purchaseStatus, message: message)
	}

	func storeObserverRestoreDidSucceed() {
		handleRestoredSucceededTransaction()
	}
}

