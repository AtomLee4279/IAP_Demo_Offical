/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays error and status messages.
*/

#import "MessagesViewController.h"

@interface MessagesViewController ()
/// Used to display a message.
@property (weak) IBOutlet NSTextField *messageLabel;
@end

@implementation MessagesViewController
#pragma mark - View Life Cycle

-(void)viewDidAppear {
    [super viewDidAppear];
    if (self.message) {
        self.messageLabel.stringValue = self.message;
    }
}
@end
