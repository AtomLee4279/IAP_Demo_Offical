/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Primary window controller. Checks whether the user is allowed to make purchases and whether the resource file containing the product identifiers
exists. Disables the UI when the user is not allowed to make any purchases.
*/

#import "Utilities.h"
#import "StoreObserver.h"
#import "WindowController.h"
#import "AppConfiguration.h"
#import "MainViewController.h"

@interface WindowController ()
@property (strong) Utilities *utility;
@property (strong) MainViewController *mainViewController;
@end

@implementation WindowController
#pragma mark - Window Life Cycle

- (void)windowDidLoad {
	[super windowDidLoad];
	self.utility = [[Utilities alloc] init];
	self.mainViewController = (MainViewController *)self.window.contentViewController;

	// First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
	if ([StoreObserver sharedInstance].isAuthorizedForPayments) {
		NSArray *identifiers = self.utility.identifiers;
		NSString *message;

		// Refresh the UI if the resource file containing the product identifiers exists. Show a message, otherwise.
		if (identifiers != nil) {
			if (identifiers.count > 0) {
				[self.mainViewController reloadViewController:PCSViewControllerNamesProducts];
			} else {
				message = [NSString stringWithFormat:@"%@.%@ %@", PCSProductIdsPlistName, PCSProductIdsPlistFileExtension, PCSMessagesEmptyResource];
				// Warn the user that the resource file does not contain anything.
				[self.mainViewController reloadViewController:PCSViewControllerNamesMessages withMessage:message];
			}
		} else {
			message = [NSString stringWithFormat:@"%@ %@.%@.", PCSMessagesResourceNotFound, PCSProductIdsPlistName, PCSProductIdsPlistFileExtension];
			// Warn the user that the resource file could not be found.
			[self.mainViewController reloadViewController:PCSViewControllerNamesMessages withMessage:message];
		}
	} else {
		// Warn the user that they are not allowed to make purchases.
		[self.mainViewController reloadViewController:PCSViewControllerNamesMessages withMessage:PCSMessagesCannotMakePayments];
	}
}

#pragma mark - Switches Between Products and Purchases Panes

- (IBAction)showProducts:(NSToolbarItem *)sender {
	[self.mainViewController reloadViewController:PCSViewControllerNamesProducts];
}


- (IBAction)showPurchases:(NSToolbarItem *)sender {
	[self.mainViewController reloadViewController:PCSViewControllerNamesPurchases];
}


#pragma mark - NSUserInterfaceValidations

- (BOOL)validateUserInterfaceItem:(nonnull id<NSValidatedUserInterfaceItem>)item {
	if (item.action == @selector(showProducts:)) {
		return ([StoreObserver sharedInstance].isAuthorizedForPayments && (self.utility.identifiers != nil && self.utility.identifiers.count > 0));
	} else if (item.action == @selector(showPurchases:)) {
		return [StoreObserver sharedInstance].isAuthorizedForPayments;
	}
	return NO;
}

@end
