/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A PrimaryViewController subclass that displays invalid product identifiers.
*/

import Cocoa

class InvalidProductIdentifiers: PrimaryViewController {
	// MARK: - Refresh UI

	/// Refreshes the UI with new invalid product identifiers.
	func reload(with identifiers: [String]) {
		data = identifiers
		self.tableView.reloadData()
	}

	// MARK: - NSTableViewDelegate

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let tableColumn = tableColumn, let cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: nil) as? NSTableCellView,
			let identifier = data[row] as? String else { return nil }

		cell.textField?.stringValue = identifier
		return cell
	}
}
