/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller to share a data model between subclasses. Allows its subclasses to display product and purchase information.
*/

import UIKit

class BaseViewController: UITableViewController {
	// MARK: - Properties

	/// Data model used by all BaseViewController subclasses.
	var data = [Section]()

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		// Returns the number of sections.
		return data.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Returns the number of rows in the section.
		return data[section].elements.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		// Returns the header title for this section.
		return data[section].type.description
	}
}

// MARK: - BaseViewController Extension

/// Extends BaseViewController to refresh the UI with new data.
extension BaseViewController {
	func reload(with data: [Section]) {
		self.data = data
		tableView.reloadData()
	}
}
