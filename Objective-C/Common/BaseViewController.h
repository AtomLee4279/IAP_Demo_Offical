/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller to share a data model between subclasses. Allows its subclasses to display product and purchase information.
*/

@import UIKit;
#import "IAPTableViewDataSource.h"

@interface BaseViewController : UITableViewController <IAPTableViewDataSource>
@property (strong) NSMutableArray *data;
@end
