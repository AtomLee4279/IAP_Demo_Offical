/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Fetches identifiers from a resource file, provides the Purchases view's data source, and creates an alert.
*/

@import StoreKit;
#import "Section.h"

#if TARGET_OS_OSX
@import Cocoa;
#else
@import UIKit;
#endif

@interface Utilities : NSObject
/// - returns: An array that will be used to populate the Purchases view.
@property (NS_NONATOMIC_IOSONLY, readonly, assign) NSArray *dataSourceForPurchasesUI;

/// - returns: An array with the product identifiers to be queried.
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *identifiers;

/// Indicates whether the user has initiated a restore.
@property (nonatomic) BOOL restoreWasCalled;

#if TARGET_OS_IOS || TARGET_OS_TV
/// - returns: An alert with a given title and message.
-(UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message;
#endif

/// - returns: A Section object matching the specified name in the data array.
-(Section *)parse:(NSArray *)data forName:(NSString *)name;
@end
