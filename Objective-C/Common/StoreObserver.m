/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implements the SKPaymentTransactionObserver protocol. Handles purchasing and restoring products using paymentQueue:updatedTransactions: .
*/

#import "StoreObserver.h"

@interface StoreObserver ()
/// Indicates whether there are restorable purchases.
@property (nonatomic) BOOL hasRestorablePurchases;
@end

@implementation StoreObserver
+ (StoreObserver *)sharedInstance {
	static dispatch_once_t onceToken;
	static StoreObserver * storeObserverSharedInstance;

	dispatch_once(&onceToken, ^{
		storeObserverSharedInstance = [[StoreObserver alloc] init];
	});
	return storeObserverSharedInstance;
}

- (instancetype)init {
	self = [super init];

	if (self != nil) {
		_hasRestorablePurchases = NO;
		_productsPurchased = [[NSMutableArray alloc] initWithCapacity:0];
		_productsRestored = [[NSMutableArray alloc] initWithCapacity:0];
		_status = PCSPurchaseStatusNone;
	}
	return self;
}
/**
 	Indicates whether the user is allowed to make payments.
 	- returns: true if the user is allowed to make payments and false, otherwise. Tell StoreManager to query the App Store when the user is allowed to
 			   make payments and there are product identifiers to be queried.
 */
-(BOOL)isAuthorizedForPayments {
	return [SKPaymentQueue canMakePayments];
}

#pragma mark - Submit Payment Request

/// Create and add a payment request to the payment queue.
-(void)buy:(SKProduct *)product {
	SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Restore All Restorable Purchases

/// Restores all previously completed purchases.
-(void)restore {
	if (self.productsRestored.count > 0) {
		[self.productsRestored removeAllObjects];
	}
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKPaymentTransactionObserver Methods

/// Called when there are transactions in the payment queue.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing: break;
			// Do not block your UI. Allow the user to continue using your app.
			case SKPaymentTransactionStateDeferred: NSLog(@"%@", PCSMessagesDeferred);
				break;
			// The purchase was successful.
			case SKPaymentTransactionStatePurchased: [self handlePurchasedTransaction:transaction];
				break;
			// The transaction failed.
			case SKPaymentTransactionStateFailed: [self handleFailedTransaction:transaction];
				break;
			// There are restored products.
			case SKPaymentTransactionStateRestored: [self handleRestoredTransaction:transaction];
				break;
			default: break;
		}
	}
}

/// Logs all transactions that have been removed from the payment queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		NSLog(@"%@ %@", transaction.payment.productIdentifier, PCSMessagesRemove);
	}
}

/// Called when an error occur while restoring purchases. Notify the user about the error.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	if (error.code != SKErrorPaymentCancelled) {
		self.status = PCSRestoreFailed;
		self.message = error.localizedDescription;

		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:PCSPurchaseNotification object:self];
		});
	}
}

/// Called when all restorable transactions have been processed by the payment queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
	NSLog(@"%@", PCSMessagesRestorable);

	if (!self.hasRestorablePurchases) {
		self.status = PCSNoRestorablePurchases;
		self.message = [NSString stringWithFormat:@"%@\n%@", PCSMessagesNoRestorablePurchases, PCSMessagesPreviouslyBought];

		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:PCSPurchaseNotification object:self];
		});
	}
}

#pragma mark - Handle Payment Transactions

/// Handles successful purchase transactions.
-(void)handlePurchasedTransaction:(SKPaymentTransaction*)transaction {
	[self.productsPurchased addObject:transaction];
	NSLog(@"%@ %@.", PCSMessagesDeliverContent, transaction.payment.productIdentifier);

	// Finish the successful transaction.
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// Handles failed purchase transactions.
-(void)handleFailedTransaction:(SKPaymentTransaction*)transaction {
	self.status = PCSPurchaseFailed;
	self.message = [NSString stringWithFormat:@"%@ %@ %@",PCSMessagesPurchaseOf, transaction.payment.productIdentifier, PCSMessagesFailed];

	if (transaction.error) {
		[self.message stringByAppendingString:[NSString stringWithFormat:@"\n%@ %@", PCSMessagesError, transaction.error.localizedDescription]];
		NSLog(@"%@ %@", PCSMessagesError, transaction.error.localizedDescription);
	}

		// Do not send any notifications when the user cancels the purchase.
	if (transaction.error.code != SKErrorPaymentCancelled) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSNotificationCenter defaultCenter] postNotificationName:PCSPurchaseNotification object:self];
		});
	}

	// Finish the failed transaction.
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// Handles restored purchase transactions.
-(void)handleRestoredTransaction:(SKPaymentTransaction*)transaction {
	self.status = PCSRestoreSucceeded;
	self.hasRestorablePurchases = true;
	[self.productsRestored addObject:transaction];
	NSLog(@"%@ %@.", PCSMessagesRestoreContent, transaction.payment.productIdentifier);

	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:PCSPurchaseNotification object:self];
	});

	// Finishes the restored transaction.
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
