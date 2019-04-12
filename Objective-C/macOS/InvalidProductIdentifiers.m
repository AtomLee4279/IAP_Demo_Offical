/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A PrimaryViewController subclass that displays invalid product identifiers.
*/

#import "InvalidProductIdentifiers.h"

@implementation InvalidProductIdentifiers
#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (cell != nil) {
        cell.textField.stringValue = self.data[row];
        return cell;
    }
    return nil;
}
@end
