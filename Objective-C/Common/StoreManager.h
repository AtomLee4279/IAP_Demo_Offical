/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Retrieves product information from the App Store using SKRequestDelegate, SKProductsRequestDelegate, SKProductsResponse, and SKProductsRequest.
 Notifies its observer with a list of products available for sale along with a list of invalid product identifiers. Logs an error message if the
 product request failed.
*/

@import StoreKit;
#import "AppConfiguration.h"

@interface StoreManager : NSObject
+ (StoreManager *)sharedInstance;

/// Indicates the cause of the product request failure.
@property (nonatomic, copy) NSString *message;

/// Provides the status of the product request.
@property (nonatomic) PCSProductRequestStatus status;

/// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers.
@property (strong) NSMutableArray *storeResponse;

/// Starts the product request with the specified identifiers.
-(void)startProductRequestWithIdentifiers:(NSArray *)identifiers;

/// - returns: Existing product's title matching the specified product identifier.
-(NSString *)titleMatchingIdentifier:(NSString *)identifier;

/// - returns: Existing product's title associated with the specified payment transaction.
-(NSString *)titleMatchingPaymentTransaction:(SKPaymentTransaction *)transaction;
@end
