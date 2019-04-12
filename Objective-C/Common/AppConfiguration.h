/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Handles the application's configuration information.
*/

@import Foundation;

#pragma mark - Hosted Download

extern NSString *const PCSHostedYes;
extern NSString *const PCSHostedNot;

#pragma mark - Messages

extern NSString *const PCSMessagesCannotMakePayments;
extern NSString *const PCSMessagesDeferred;
extern NSString *const PCSMessagesDeliverContent;
extern NSString *const PCSMessagesEmptyResource;
extern NSString *const PCSMessagesError;
extern NSString *const PCSMessagesFailed;
extern NSString *const PCSMessagesNoRestorablePurchases;
extern NSString *const PCSMessagesOk;
extern NSString *const PCSMessagesPurchaseOf;
extern NSString *const PCSMessagesPurchaseStatus;
extern NSString *const PCSMessagesPreviouslyBought;
extern NSString *const PCSMessagesProductRequestStatus;
extern NSString *const PCSMessagesRemove;
extern NSString *const PCSMessagesResourceNotFound;
extern NSString *const PCSMessagesRestorable;
extern NSString *const PCSMessagesRestoreContent;
extern NSString *const PCSMessagesStatus;
extern NSString *const PCSMessagesNoPurchasesAvailable;
extern NSString *const PCSMessagesUseStoreRestore;

#pragma mark - Notifications

extern NSString *const PCSProductRequestNotification;
extern NSString *const PCSPurchaseNotification;
extern NSString *const PCSRestoredWasCalledNotification;

typedef NS_ENUM(NSInteger, PCSProductRequestStatus) {
	PCSIdentifiersNotFound, // indicates that there are some invalid product identifiers.
	PCSProductsFound,// Indicates that there are some valid products.
	PCSRequestFailed, // Indicates that the product request has failed.
	PCSStoreResponse, // Indicates that there are some valid products, invalid product identifiers, or both available.
	PCSProductRequestStatusNone // The PCSProductRequest notification has not occured yet. This is the default value.
};

typedef NS_ENUM(NSInteger, PCSPurchaseStatus) {
	PCSPurchaseFailed, // Indicates that the purchase was unsuccessful.
	PCSPPurchaseSucceeded, // Indicates that the purchase was successful.
	PCSRestoreFailed, // Indicates that restoring purchases was unsuccessful.
	PCSRestoreSucceeded, // Indicates that restoring purchases was successful.
	PCSNoRestorablePurchases, // Indicates that there are no restorable purchases.
	PCSPurchaseStatusNone // The PCSPurchase notification has not occured yet. This is the default value.
};

#pragma mark - Payment Transaction Details Labels
extern NSString *const PCSPaymentTransactionDetailsLabelsIdentifier;
extern NSString *const PCSPaymentTransactionDetailsLabelsContentLength;
extern NSString *const PCSPaymentTransactionDetailsLabelsContentVersion;
extern NSString *const PCSPaymentTransactionDetailsLabelsTransactionDate;
extern NSString *const PCSPaymentTransactionDetailsLabelsTransactionIdentifier;

#pragma mark - Payment Transaction Details Table

extern NSString *const PCSPaymentTransactionDetailsOriginalTransaction;
extern NSString *const PCSPaymentTransactionDetailsProductIdentifier;
extern NSString *const PCSPaymentTransactionDetailsTransactionDate;
extern NSString *const PCSPaymentTransactionDetailsTransactionIdentifier;

#pragma mark - Products Table Header Section

extern NSString *const PCSProductsAvailableProducts;
extern NSString *const PCSProductsInvalidIdentifiers;

#pragma mark - Purchases Table Header Section

extern NSString *const PCSPurchasesDownload;
extern NSString *const PCSPurchasesPurchased;
extern NSString *const PCSPurchasesRestored;

#pragma mark - Resource File

extern NSString *const PCSProductIdsPlistName;
extern NSString *const PCSProductIdsPlistFileExtension;

#pragma mark - View Controller Identifiers

extern NSString *const PCSViewControllerIdentifiersAvailableProducts;
extern NSString *const PCSViewControllerIdentifiersInvalidProductIdentifiers;
extern NSString *const PCSViewControllerIdentifiersMessages;
extern NSString *const PCSViewControllerIdentifiersProducts;
extern NSString *const PCSViewControllerIdentifiersPurchases;

#pragma mark - View Controller Names

extern NSString *const PCSViewControllerNamesMessages;
extern NSString *const PCSViewControllerNamesProducts;
extern NSString *const PCSViewControllerNamesPurchases;
