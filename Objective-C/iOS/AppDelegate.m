/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate class. Registers and removes an observer from the payment queue.
*/

@import StoreKit;
#import "AppDelegate.h"
#import "StoreObserver.h"

@implementation AppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Attach an observer to the payment queue.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Remove the observer.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: [StoreObserver sharedInstance]];
}

@end
