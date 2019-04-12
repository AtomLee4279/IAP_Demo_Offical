/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages the child view controllers: AvailableProducts, InvalidProductIdentifiers, PurchasesDetails, and MessagesViewController. Requests product
 information about a list of product identifiers using StoreManager. Calls StoreObserver to implement the restoration of purchases. Displays a pop-up
 menu that allows users to toggle between available products and invalid product identifiers; also between purchased transactions and restored
 transactions.
*/

@import Cocoa;

@interface MainViewController : NSViewController
-(void)reloadViewController:(NSString *)viewController;
-(void)reloadViewController:(NSString *)viewController withMessage:(NSString*)message;
@end
