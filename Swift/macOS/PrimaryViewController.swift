/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller to share a table view between subclasses. Allows its subclasses to display available products, invalid identifiers,
purchases, and restored purchases.
*/

import Cocoa

class PrimaryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	// MARK: - Properties

	/// Data model used by all PrimaryViewController subclasses.
	var data = [Any]()

	/// Table view used by all PrimaryViewController subclasses.
	@IBOutlet weak var tableView: NSTableView!

	// MARK: - NSTable​View​Data​Source

	func numberOfRows(in tableView: NSTableView) -> Int {
		return data.count
	}
}
