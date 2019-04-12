/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A BaseViewController subclass that provides details about a purchase. The purchase contains the product identifier, transaction identifier, and
 transaction date for a regular purchase. It includes the content identifier, content version, and content length for a hosted product. It
 contains the original transaction's identifier and date for a restored purchase.
*/

@import StoreKit;
#import "Section.h"
#import "AppConfiguration.h"
#import "PaymentTransactionDetails.h"

typedef NS_ENUM(NSInteger, PaymentTransactionDetailsSection) {
	PaymentTransactionDetailsSectionInformation = 0,
	PaymentTransactionDetailsSectionDownload,
	PaymentTransactionDetailsSectionOriginalTransaction
};

NSString *const kBasicCellIdentifier = @"basic";
NSString *const kCustomCellIdentifier = @"custom";

@implementation PaymentTransactionDetails
#pragma mark - UITable​View​Data​Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Section *section = (self.data)[indexPath.section];

	if ([section.name isEqualToString:PCSPurchasesDownload] || [section.name isEqualToString:PCSPaymentTransactionDetailsOriginalTransaction]) {
		return [tableView dequeueReusableCellWithIdentifier:kCustomCellIdentifier forIndexPath:indexPath];
	} else {
		return [tableView dequeueReusableCellWithIdentifier:kBasicCellIdentifier forIndexPath:indexPath];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	Section *section = (self.data)[indexPath.section];
	NSArray *transactions = section.elements;

	if ([section.name isEqualToString:PCSPurchasesDownload]) {
		NSDictionary *dictionary = transactions[indexPath.row];

		switch (indexPath.row) {
			case PaymentTransactionDetailsSectionInformation:
				cell.textLabel.text = PCSPaymentTransactionDetailsLabelsIdentifier;
				cell.detailTextLabel.text = dictionary[PCSPaymentTransactionDetailsLabelsIdentifier];
				break;
			case PaymentTransactionDetailsSectionDownload:
				cell.textLabel.text = PCSPaymentTransactionDetailsLabelsContentVersion;
				cell.detailTextLabel.text = dictionary[PCSPaymentTransactionDetailsLabelsContentVersion];
				break;
			case PaymentTransactionDetailsSectionOriginalTransaction:
				cell.textLabel.text = PCSPaymentTransactionDetailsLabelsContentLength;
				cell.detailTextLabel.text = dictionary[PCSPaymentTransactionDetailsLabelsContentLength];
				break;
		}
	} else if ([section.name isEqualToString:PCSPaymentTransactionDetailsOriginalTransaction]) {
		NSDictionary *dictionary = transactions[indexPath.row];

		switch (indexPath.row) {
			case PaymentTransactionDetailsSectionInformation:
				cell.textLabel.text = PCSPaymentTransactionDetailsLabelsTransactionIdentifier;
				cell.detailTextLabel.text = dictionary[PCSPaymentTransactionDetailsLabelsTransactionIdentifier];
				break;
			case PaymentTransactionDetailsSectionDownload:
				cell.textLabel.text = PCSPaymentTransactionDetailsLabelsTransactionDate;
				cell.detailTextLabel.text = dictionary[PCSPaymentTransactionDetailsLabelsTransactionDate];
				break;
		}
	} else {
		cell.textLabel.text = transactions.firstObject;
	}
}

@end
