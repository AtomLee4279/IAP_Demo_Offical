/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates a category for the SKProduct class.
*/

@import StoreKit;

@interface SKProduct (SKProductAdditions)
/// - returns: The cost of the product formatted in the local currency.
-(NSString *)regularPrice;
@end
