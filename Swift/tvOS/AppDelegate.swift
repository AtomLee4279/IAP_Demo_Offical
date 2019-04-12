/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate class. Registers and removes an observer from the payment queue.
*/

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Attach an observer to the payment queue.
		SKPaymentQueue.default().add(StoreObserver.shared)
		return true
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Remove the observer.
		SKPaymentQueue.default().remove(StoreObserver.shared)
	}
}
