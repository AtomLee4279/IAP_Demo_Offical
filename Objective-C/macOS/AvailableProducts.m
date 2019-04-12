/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A PrimaryViewController subclass that displays a list of products available for sale in the App Store. Displays the localized title and price of each
 of these products using SKProduct. Indicates whether each product is hosted or not. Calls StoreObserver to implement a purchase when a user taps a
 product.
*/

@import StoreKit;
#import "StoreManager.h"
#import "StoreObserver.h"
#import "AppConfiguration.h"
#import "AvailableProducts.h"
#import "SKProduct+SKProductAdditions.h"

NSString *const kTableCellViewIdentifiersTitle = @"localizedTitle";
NSString *const kTableCellViewIdentifiersHosted = @"downloadable";
NSString *const kTableCellViewIdentifiersPrice = @"price";

@implementation AvailableProducts
#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	SKProduct *product = (SKProduct *)self.data[row];
	NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

	if (cell !=  nil) {
		if ([tableColumn.identifier isEqualToString:kTableCellViewIdentifiersTitle]) {
				// Display the localized title of the product.
			cell.textField.stringValue = product.localizedTitle;
		} else if ([tableColumn.identifier isEqualToString:kTableCellViewIdentifiersHosted]) {
				// Display Yes if the product is hosted and No, otherwise.
			cell.textField.stringValue = (product.downloadable) ? PCSHostedYes : PCSHostedNot;
		} else if ([tableColumn.identifier isEqualToString:kTableCellViewIdentifiersPrice]) {
				// Display the product's price in the locale and currency returned by the App Store.
			cell.textField.stringValue = product.regularPrice;
		}
		return cell;
	}
	return nil;
}

/// Starts a purchase when the user taps a row.
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger selectedRow = (self.tableView).selectedRow;

	if (selectedRow >= 0 && (self.data.count > 0)) {
		SKProduct *product = (SKProduct *)self.data[selectedRow];
		// Attempt to purchase the selected product.
		[[StoreObserver sharedInstance] buy:product];
	}
}

@end
