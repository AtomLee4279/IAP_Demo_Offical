/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller to share a table view between subclasses. Allows its subclasses to display available products, invalid identifiers,
 purchases, and restored purchases.
*/

#import "PrimaryViewController.h"

@implementation PrimaryViewController
#pragma mark - Reload UI

/// Reloads the UI with new products, invalid identifiers, or purchases.
-(void)reloadUIWithData:(NSMutableArray *)data {
	self.data = data;
	[self.tableView reloadData];
}

#pragma mark - NSTable​View​Data​Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return self.data.count;
}

@end

