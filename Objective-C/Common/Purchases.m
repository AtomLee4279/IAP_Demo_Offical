/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A BaseViewController subclass that shows two lists: purchased products and restored ones. When tapping a list item, it calls PaymentTransactionDetails
 to display its purchase information using SKPaymentTransaction.
*/

@import StoreKit;
#import "Section.h"
#import "Purchases.h"
#import "StoreManager.h"
#import "AppConfiguration.h"
#import "PaymentTransactionDetails.h"
#import "NSDateFormatter+DateFormatter.h"
#import "SKDownload+SKDownloadAdditions.h"

NSString *const kPurchaseCellIdentifier = @"purchase";
NSString *const kShowPaymentTransactionSegueIdentifier = @"showPaymentTransaction";

@implementation Purchases
#pragma mark - UITable​View​Data​Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [tableView dequeueReusableCellWithIdentifier:kPurchaseCellIdentifier forIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	Section *section = self.data[indexPath.section];
	NSArray *content = section.elements;

	SKPaymentTransaction *paymentTransaction = content[indexPath.row];
	NSString *title = ([[StoreManager sharedInstance] titleMatchingIdentifier:paymentTransaction.payment.productIdentifier]);

	// Display the product's title associated with the payment's product identifier if it exists or the product identifier, otherwise.
	cell.textLabel.text = (title.length > 0) ? title : paymentTransaction.payment.productIdentifier;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kShowPaymentTransactionSegueIdentifier]) {
		NSInteger selectedRowIndex = (self.tableView).indexPathForSelectedRow.section;
		Section *section = self.data[selectedRowIndex];

		NSArray *purchases = section.elements;
		SKPaymentTransaction *paymentTransaction = purchases[(self.tableView).indexPathForSelectedRow.row];
		NSMutableArray *purchaseDetails = [[NSMutableArray alloc] init];

#if TARGET_OS_IOS
		NSDateFormatter *dateFormatter = [NSDateFormatter shortStyle];
#else
		NSDateFormatter *dateFormatter = [NSDateFormatter longStyle];
#endif

		// Add the product identifier, transaction id, and transaction date to purchaseDetails.
		[purchaseDetails addObject:[[Section alloc] initWithName:PCSPaymentTransactionDetailsProductIdentifier
														elements:@[paymentTransaction.payment.productIdentifier]]];
		[purchaseDetails addObject:[[Section alloc] initWithName:PCSPaymentTransactionDetailsTransactionIdentifier
														elements:@[paymentTransaction.transactionIdentifier]]];
		[purchaseDetails addObject:[[Section alloc] initWithName:PCSPaymentTransactionDetailsTransactionDate
														elements:@[[dateFormatter stringFromDate:paymentTransaction.transactionDate]]]];

		NSArray *allDownloads = paymentTransaction.downloads;

		// If this product is hosted, add its first download to purchaseDetails.
		if (allDownloads.count > 0) {
			// We are only showing the first download.
			SKDownload *firstDownload = allDownloads[0];

			NSDictionary *identifier = @{PCSPaymentTransactionDetailsLabelsIdentifier:firstDownload.contentIdentifier};
			NSDictionary *version = @{PCSPaymentTransactionDetailsLabelsContentVersion:firstDownload.contentVersion};
			NSDictionary *contentLength = @{PCSPaymentTransactionDetailsLabelsContentLength:firstDownload.downloadContentSize};

			// Add the identifier, version, and length of a download to purchaseDetails.
			[purchaseDetails addObject:[[Section alloc] initWithName:PCSPurchasesDownload elements:@[identifier, version, contentLength]]];
		}

		// If the product is a restored one, add its original transaction's transaction id and transaction date to purchaseDetails.
		SKPaymentTransaction *originalTransaction = paymentTransaction.originalTransaction;
		if (originalTransaction != nil) {
			NSDictionary *transactionID = @{PCSPaymentTransactionDetailsLabelsTransactionIdentifier: originalTransaction.transactionIdentifier};
			NSString *formattedDate = [dateFormatter stringFromDate:originalTransaction.transactionDate];
			NSDictionary *transactionDate = @{PCSPaymentTransactionDetailsLabelsTransactionDate:formattedDate};

			[purchaseDetails addObject:[[Section alloc] initWithName:PCSPaymentTransactionDetailsOriginalTransaction
															elements:[NSMutableArray arrayWithObjects:transactionID, transactionDate, nil]]];
		}

		PaymentTransactionDetails *transactionDetails = (PaymentTransactionDetails *)segue.destinationViewController;
		transactionDetails.data = [NSMutableArray arrayWithArray:purchaseDetails];
		transactionDetails.title = [[StoreManager sharedInstance] titleMatchingPaymentTransaction:paymentTransaction];
	}
}

@end
