/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A BaseViewController subclass that provides details about a purchase. The purchase contains the product identifier, transaction identifier, and
transaction date for a regular purchase. It includes the content identifier, content version, and content length for a hosted product. It
contains the original transaction's identifier and date for a restored purchase.
*/

import UIKit
import StoreKit

class PaymentTransactionDetails: BaseViewController {
	// MARK: - Types

	fileprivate struct CellIdentifiers {
		static let basic = "basic"
		static let custom = "custom"
	}

	// MARK: - Properties

	var tableViewCellLabels: [SectionType: [String]] {
		let downloads = [DownloadContentLabels.contentIdentifier, DownloadContentLabels.contentVersion, DownloadContentLabels.contentLength]
		let originalTransactions = [DownloadContentLabels.transactionIdentifier, DownloadContentLabels.transactionDate]

		return [.download: downloads, .originalTransaction: originalTransactions]
	}

	// MARK: - UITable​View​Data​Source

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = data[indexPath.section]

		if section.type == .download || section.type == .originalTransaction {
			return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.custom, for: indexPath)
		} else {
			return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.basic, for: indexPath)
		}
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let section = data[indexPath.section]

		if section.type == .download || section.type == .originalTransaction {
			let transactions = section.elements
			guard let dictionary = transactions[indexPath.row] as? [String: String] else { return }

			let items = tableViewCellLabels[section.type]
			guard let label = items?[indexPath.row] else { fatalError("\(Messages.unknownDetail) \(indexPath.row)).") }

			cell.textLabel!.text = label
			cell.detailTextLabel!.text = dictionary[label]

		} else {
			guard let details = section.elements as? [String] else { return }
			cell.textLabel!.text = details.first
		}
	}
}

