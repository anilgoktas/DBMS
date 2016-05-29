//
//  ViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class TablesViewController: NSViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        private struct TableWindowController {
            static let identifier = "TableWindowController"
        }
    }
    
    private struct TableView {
        private enum Column: String {
            case TableName = "Table Name"
            case RowCount = "Row Count"
        }
        
        private enum CellIdentifier: String {
            case TableName = "TableNameCell"
            case RowCount = "RowCountCell"
        }
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: - Properties
    
    var tableWindowController: NSWindowController?
    var rightClickedRow: Int?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func tableViewDidDoubleClick(sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        tableWindowController = storyboard.instantiateControllerWithIdentifier(Constants.TableWindowController.identifier) as? NSWindowController
        
        guard let tableViewController = tableWindowController?.contentViewController as? TableViewController
        else { return }
        
        tableViewController.entity = Database.sharedDatabase.entity(index: tableView.selectedRow)
        tableViewController.table = Database.sharedDatabase.table(index: tableView.selectedRow)
        
        tableWindowController?.showWindow(nil)
    }
    
}

// MARK: - Configurable

extension TablesViewController {
    
    private func configureObservers() {
        notificationCenter.addObserverForName("tableUpdated", object: nil, queue: mainOperationQueue) { (notification) in
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - NSTableViewDataSource

extension TablesViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return Database.sharedDatabase.tableCount
    }
    
}

// MARK: - NSTableViewDelegate

extension TablesViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier: String
        let stringValue: String
        
        // Configure cellIdentifier and stringValue
        if tableColumn?.title == TableView.Column.TableName.rawValue {
            cellIdentifier = TableView.CellIdentifier.TableName.rawValue
            stringValue = Database.sharedDatabase.entity(index: row).entityName
        } else {
            cellIdentifier = TableView.CellIdentifier.RowCount.rawValue
            stringValue = "\(Database.sharedDatabase.table(index: row).count)"
        }
        
        // Configure cell
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = stringValue
            return cell
        }
        return nil
    }
    
}