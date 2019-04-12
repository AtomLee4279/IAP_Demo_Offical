/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate class. Registers and removes an observer from the payment queue. Calls StoreObserver to implement the restoration of
 purchases.
*/

@import StoreKit;
#import "AppDelegate.h"
#import "StoreObserver.h"

@interface AppDelegate ()
/// Indicates whether we have registered with the payment queue.
@property (nonatomic) BOOL hasRegisteredForNotifications;
@end

@implementation AppDelegate

#pragma mark - Restore All Appropriate Purchases

/// Called when selecting InAppPurchases > Store > Restore in the app.
- (IBAction)restore:(NSMenuItem *)sender {
		// Calls StoreObserver to restore all restorable purchases.
	[[StoreObserver sharedInstance] restore];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSURL *url = [NSBundle mainBundle].appStoreReceiptURL;
	NSData *receipt = [NSData dataWithContentsOfURL:url];

	if (receipt != nil) {
		if ([StoreObserver sharedInstance].isAuthorizedForPayments) {
			// Attach an observer to the payment queue.
			[[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
			self.hasRegisteredForNotifications = YES;
		}
	} else {
		exit(173);
	}
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (self.hasRegisteredForNotifications) {
			// Remove the observer.
		[[SKPaymentQueue defaultQueue] removeTransactionObserver:[StoreObserver sharedInstance]];
	}
}

#pragma mark - NSUserInterfaceValidations

- (BOOL)validateUserInterfaceItem:(nonnull id<NSValidatedUserInterfaceItem>)item {
	if (item.action == @selector(restore:)){
		return [StoreObserver sharedInstance].isAuthorizedForPayments;
	}
	return NO;
}

@end
