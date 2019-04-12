/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays error and status messages.
*/

import Cocoa

class MessagesViewController: NSViewController {
    // MARK: - Properties

    /// Message to be displayed.
    var message: String?

    /// Used to display a message.
    @IBOutlet fileprivate weak var messageLabel: NSTextField!

    // MARK: - View Life Cycle

    override func viewDidAppear() {
        super.viewDidAppear()
        if let message = message {
            messageLabel.stringValue = message
        }
    }
}
