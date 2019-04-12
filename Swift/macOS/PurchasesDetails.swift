/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A PrimaryViewController subclass that is used to display purchases or restored ones. Provides details about a selected purchase. The purchase con-
tains the product identifier, transaction identifier, and transaction date for a regular purchase; the content identifier, content version, and
content length for a hosted product; and the original transaction's identifier and date for a restored product.
*/

import Cocoa
import StoreKit

class PurchasesDetails: PrimaryViewController {
	// MARK: - Properties

	@IBOutlet weak fileprivate var stackView: NSStackView!
	@IBOutlet weak fileprivate var productID: NSTextField!
	@IBOutlet weak fileprivate var transactionID: NSTextField!
	@IBOutlet weak fileprivate var transactionDate: NSTextField!

	@IBOutlet weak fileprivate var download: NSBox!
	@IBOutlet weak fileprivate var downloadID: NSTextField!
	@IBOutlet weak fileprivate var contentVersion: NSTextField!
	@IBOutlet weak fileprivate var contentLength: NSTextField!

	@IBOutlet weak fileprivate var originalTransaction: NSBox!
	@IBOutlet weak fileprivate var originalTransactionID: NSTextField!
	@IBOutlet weak fileprivate var originalTransactionDate: NSTextField!

	// MARK: - View Life Cycle

	override func viewDidAppear() {
		super.viewDidAppear()
		download.hide()
		originalTransaction.hide()
		reloadTableAndSelectFirstRowIfNecessary()
	}

	// MARK: - Update UI

	/// Refreshes the UI with new payment transactions.
	func reload(with transactions: [SKPaymentTransaction]) {
		data = transactions
		self.tableView.reloadData()
		reloadTableAndSelectFirstRowIfNecessary()
	}

	/// Reloads the table view and programmatically selects a purchase.
	fileprivate func reloadTableAndSelectFirstRowIfNecessary() {
		// Select the first purchase and display its information if no row are currently selected and display the current selection, otherwise.
		let selection = (tableView.selectedRowIndexes.isEmpty) ? IndexSet(integer: 0) : tableView.selectedRowIndexes

		tableView.reloadData()
		tableView.selectRowIndexes(selection, byExtendingSelection: false)
	}

	// MARK: - NSTableViewDelegate

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let tableColumn = tableColumn, let cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: nil) as? NSTableCellView,
			let transaction = data[row] as? SKPaymentTransaction else { return nil }

		// Display the product's title associated with the payment's product identifier.
		cell.textField?.stringValue = StoreManager.shared.title(matchingPaymentTransaction: transaction)
		return cell
	}

	/// Displays information about the selected purchase or restored one.
	func tableViewSelectionDidChange(_ notification: Notification) {
		let selectedRow = tableView.selectedRow
		guard (selectedRow >= 0) && (!data.isEmpty) else { return }

		download.hide()
		originalTransaction.hide()

		guard let transaction = data[selectedRow] as? SKPaymentTransaction else { return }

		productID.stringValue = transaction.payment.productIdentifier
		transactionID.stringValue = transaction.transactionIdentifier!
		transactionDate.stringValue = DateFormatter.long(transaction.transactionDate!)

		let allDownloads = transaction.downloads
		// Display download information if they are any.
		if !allDownloads.isEmpty {
			download.show()

			// We are only showing the first download.
			if let firstDownload = allDownloads.first {
				downloadID.stringValue = firstDownload.contentIdentifier
				contentVersion.stringValue = firstDownload.contentVersion
				contentLength.stringValue = firstDownload.downloadContentSize
			}
		}
		// Display restored transactions if they exist.
		guard let transactionIdentifier = transaction.original?.transactionIdentifier, let transactionDate = transaction.original?.transactionDate
			else { return }

		originalTransaction.show()
		originalTransactionID.stringValue = transactionIdentifier
		originalTransactionDate.stringValue = DateFormatter.long(transactionDate)
	}
}
