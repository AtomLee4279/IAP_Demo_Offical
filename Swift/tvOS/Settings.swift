/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays a "Restore all restorable purchases" feature that allows you to restore all previously bought non-consumable and auto-renewable
subscriptions.
*/

import UIKit
import StoreKit

class Settings: UITableViewController {
	// MARK: - Types

	struct CellIdentifiers {
		static let restore = "restore"
	}

	weak var delegate: SettingsDelegate?

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)

		if let identifier = cell?.reuseIdentifier, identifier == CellIdentifiers.restore {
			StoreObserver.shared.restore()
			DispatchQueue.main.async {
				self.delegate?.settingDidSelectRestore()
			}
		}
	}
}
