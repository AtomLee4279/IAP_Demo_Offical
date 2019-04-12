/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A BaseViewController subclass that displays a list of products available for sale in the App Store. Displays the localized title and price
 of each of these products using SKProduct. Also shows a list of product identifiers not recognized by the App Store if applicable. Calls
 StoreObserver to implement a purchase when a user taps a product.
*/

#import "BaseViewController.h"

@interface Products : BaseViewController
@end
