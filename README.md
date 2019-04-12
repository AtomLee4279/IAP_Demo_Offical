# Offering, Completing, and Restoring In-App Purchases 
Fetch, complete, and restore transactions in your app.

## Overview
This sample code demonstrates how to retrieve, display and restore in-app purchases using the StoreKit framework. To start, your app should register and use a single transaction queue observer to manage all payment transactions and handle all transactions states at launch. The transaction queue observer should be a shared instance of a custom class that conforms to the [SKPaymentTransactionObserver](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver) protocol. Be sure to remove it when the app is about to be terminated. See [Setting Up the Transaction Observer and Payment Queue](https://developer.apple.com/documentation/storekit/in-app_purchase/setting_up_the_transaction_observer_and_payment_queue) for more information.

Your app should confirm that the user is authorized to make payments on the device before fetching localized product information from the App Store. Present only products that are actually available for purchase in your app's UI. If your app sells non-consumable, auto-renewable subscription or non-renewing subscription products, you must provide users with the ability to restore them. Be sure to provide the purchased or restored content before finishing the payment transaction.

This sample, which supports the iOS, macOS, and tvOS platforms, builds the `InAppPurchases` app. 
After launching, `InAppPurchases` queries the App Store about product identifiers saved in the `Products.plist` file. It updates its UI with the App Store's response, which may include available products for sale, unrecognized product identifiers, or both. Tap any product available for sale in the UI to purchase it. The app has a `Restore` button (iOS), `Store > Restore` menu item (macOS), or `Settings > Restore all restorable purchases` (tvOS), which allows users to restore non-consumable products and auto-renewable suscriptions. Tapping any purchased item brings up purchase information such as product identifier, transaction identifier, and transaction date. When the purchased item is a hosted product, the purchase information additionally includes its content identifier, content version, and content length. When the purchase is a restored one, the purchase information also contains its original transaction's identifier and date. 


## Get Started 
Before you can run and test this sample, you need to:
1. Start with a completed app that supports in-app purchases and has some in-app purchases configured in App Store Connect. See 
steps 1 and 2 of  [Workflow for configuring in-app purchases](https://help.apple.com/app-store-connect/#/devb57be10e7) for more information.

2. Create a sandbox test user account in the App Store Connect. See [Create a sandbox tester account](https://help.apple.com/app-store-connect/#/dev8b997bee1) for details.

3. Open this sample in Xcode, select the target that you wish to build, change its _bundle ID_ to one that supports in-app purchase, then select
the right team to let Xcode automatically manage your provisioning profile. See [Assign a project to a team](https://help.apple.com/xcode/mac/current/#/dev23aab79b4) for details.

4. Open the _ProductIds.plist_ file in the sample and update its content with your existing in-app purchases' product IDs.

5. Build the sample, read  the [If a code signing error occurs](https://help.apple.com/xcode/mac/current/#/dev01865b392) document if you are running into any code-signing issues. Run its iOS and tvOS versions on an iOS and tvOS device, respectively. 
Launch its macOS version from the Finder rather than from Xcode the first time in order to obtain a receipt. macOS displays a "Sign in to download from the App Store." dialog. Enter your sandbox test user account and password as requested. The sandbox provides you with a new receipt upon successful authentication.

6. The sample queries the App Store about the product identifiers contained in _ProductIds.plist_ upon launching. When successful, it displays a list of products available for sale in the App Store. Tap any product from that list to purchase it. Use your sandbox test user account created in step 2 when prompted by StoreKit to authenticate the purchase.
When the product requests fails, see [invalidProductIdentifiers](https://developer.apple.com/documentation/storekit/skproductsresponse/1505985-invalidproductidentifiers)' discussion for various reasons for which the App Store may return invalid product identifiers.


## Display Available Products for Sale with Localized Pricing
Before presenting products for sale in your app, first check whether the user is authorized to make payments on the device. 
``` swift
var isAuthorizedForPayments: Bool {
	return SKPaymentQueue.canMakePayments()
}
```

If the user is authorized to make payments on the device, send a products request to the App Store. Querying the App Store ensures that your app will only present your users with products available for purchase. Initialize the products request with a list of product identifiers associated with products that you wish to sell in your app; see [Product ID](https://help.apple.com/app-store-connect/#/dev84b80958f) for more information. Be sure to keep a strong reference to the products request object; it may be released before the request completes.
``` swift
fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
	// Create a set for the product identifiers.
	let productIdentifiers = Set(identifiers)

	// Initialize the product request with the above identifiers.
	productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
	productRequest.delegate = self

	// Send the request to the App Store.
	productRequest.start()
}
```
[View in Source](x-source-tag://FetchProductInformation)

The App Store responds to your products request with an `SKResponse` object. Its `products` property contains information about all the products that are actually available for purchase in the App Store; use its content to update your app's UI. The response's `invalidProductIdentifiers` property includes all product identifiers that were not recognized by the App Store; see the [invalidProductIdentifiers](https://developer.apple.com/documentation/storekit/skproductsresponse/1505985-invalidproductidentifiers)' discussion for various reasons for which the App Store may return invalid product identifiers.
``` swift
// products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
if !response.products.isEmpty {
	availableProducts = response.products
	storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
}

// invalidProductIdentifiers contains all product identifiers not recognized by the App Store.
if !response.invalidProductIdentifiers.isEmpty {
	invalidProductIdentifiers = response.invalidProductIdentifiers
	storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
}
```
[View in Source](x-source-tag://ProductRequest) 

To display the price of a product in your app's UI, use the locale and currency returned by the App Store. For instance, consider a user who is logged into the French App Store and their device uses the United States locale. When attempting to purchase a product, the App Store will display the product's price in euros. Thus, converting and showing the product's price in U.S. dollars to match the device's locale in your app would be incorrect.
``` swift
extension SKProduct {
	/// - returns: The cost of the product formatted in the local currency.
	var regularPrice: String? {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = self.priceLocale
		return formatter.string(from: self.price)
	}
}
```


## Handle Payment Transaction States
When a transaction is pending in the payment queue, StoreKit notifies your transaction observer by calling its [paymentQueue(_:updatedTransactions:)](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver/1506107-paymentqueue). Every transaction has five possible states, including `.purchasing`, `.purchased`, `.failed`, `.restored`, and `.deferred`; see [`SKPaymentTransactionState`](https://developer.apple.com/documentation/storekit/skpaymenttransactionstate) for more information. Make sure that your observer's `paymentQueue(_:updatedTransactions:)` can respond to any of these states at any time. Implement the [paymentQueue(_:updatedDownloads:)](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver/1506073-paymentqueue) method on your observer, if your app provides products hosted by Apple.
``` swift
/// Called when there are transactions in the payment queue.
func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
	for transaction in transactions {
		switch transaction.transactionState {
		case .purchasing: break
		// Do not block your UI. Allow the user to continue using your app.
		case .deferred: print(Messages.deferred)
		// The purchase was successful.
		case .purchased: handlePurchased(transaction)
		// The transaction failed.
		case .failed: handleFailed(transaction)
		// There are restored products.
		case .restored: handleRestored(transaction)
		@unknown default: fatalError("\(Messages.unknownDefault)")
		}
	}
}
```

When a transaction fails, inspect its `error` property to determine what happened. Only display errors with an error code other than from `.paymentCancelled`. 
``` swift
if let error = transaction.error {
	message += "\n\(Messages.error) \(error.localizedDescription)"
	print("\(Messages.error) \(error.localizedDescription)")
}

// Do not send any notifications when the user cancels the purchase.
if (transaction.error as? SKError)?.code != .paymentCancelled {
	DispatchQueue.main.async {
		self.delegate?.storeObserverDidReceiveMessage(message)
	}
}
```

When the user defers a transaction, you should avoid blocking your app's UI while waiting for the transaction to be updated. Allow the user to continue using your app.


## Restore Completed Purchases
If your app sells non-consumable, auto-renewable subscription, or non-renewing subscription products, you must provide a UI that allows them to be restored. Your customers expect your content to be available on all their devices and indefinitely; see [In-App Purchase > Understand Product Types](https://developer.apple.com/documentation/storekit/in-app_purchase) for more information.
``` swift
/// Called when tapping the "Restore" button in the UI.
@IBAction func restore(_ sender: UIBarButtonItem) {
	// Calls StoreObserver to restore all restorable purchases.
	StoreObserver.shared.restore()
}
```

Use `SKPaymentQueue`'s [restoreCompletedTransactions](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506123-restorecompletedtransactions) to restore non-consumables and auto-renewable subscriptions in your app. StoreKit notifies your transaction observer by calling its [paymentQueue(_:updatedTransactions:)](https://developer.apple.com/documentation/storekit/skpaymenttransactionobserver/1506107-paymentqueue) with a transaction state of `restored` for every restored transaction. If restoring fails, see [restoreCompletedTransactions](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506123-restorecompletedtransactions)' discussion for details on how to resolve it. Restoring non-renewing subscriptions is not within the scope of this sample.


## Provide Content and Finish the Transaction

Deliver the content or unlock the purchased functionality when your app receives a transaction whose state is `.purchased`, or  `.restored`. These states indicate that a payment was received for the product and you should now deliver it to the customer. If your purchased product includes hosted content from the App Store, be sure to call `SKPaymentQueue`'s [start(_:)](https://developer.apple.com/documentation/storekit/skpaymentqueue/1505998-start) to download the content.

Transactions stay in the payment queue and StoreKit will call your persistent observer’s `paymentQueue(_:updatedTransactions:)` every time your app launches or resumes from the background until they are removed. As a result, your customers may be asked repeatedly to authenticate their purchases or be prevented from purchasing your products.

Call [finishTransaction(_:)](https://developer.apple.com/documentation/storekit/skpaymentqueue/1506003-finishtransaction) on transactions whose state is  `.failed`,  `.purchased`, or  `.restored` to remove them from the queue.
Finished transactions are not recoverable. Therefore, be sure to provide your content, download all Apple-hosted content of a product, or complete your purchase process before finishing your transaction.
``` swift
// Finish the successful transaction.
SKPaymentQueue.default().finishTransaction(transaction)
```
