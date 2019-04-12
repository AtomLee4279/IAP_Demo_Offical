/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller to share a table view between subclasses. Allows its subclasses to display available products, invalid identifiers,
 purchases, and restored purchases.
*/

@import Cocoa;

@interface PrimaryViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
/// Data model used by all BaseViewController subclasses.
@property (strong) NSMutableArray *data;
/// Table view used by all BaseViewController subclasses.
@property (weak) IBOutlet NSTableView *tableView;
/// Reloads the UI with new products, invalid identifiers, or purchases.
-(void)reloadUIWithData:(NSMutableArray *)data;
@end
