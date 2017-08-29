//
//  TableViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/14/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class TableViewController: NSViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        enum Identifier: String {
            case editWindowController = "EditWindowController"
        }
    }
    
    private struct TableView {
        private struct Cell {
            static let identifier = "TableCell"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: - Properties
    
    var editWindowController: NSWindowController?
    var rightClickedRow: Int?
    
    //typealias TableType
    
    var entity: Entity.Type! {
        didSet {
            view.window?.title = entity.entityName
            configureTableColumns()
        }
    }
    var table = [AnyObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - Configurable

extension TableViewController {
    
    private func configureObservers() {
        notificationCenter.addObserverForName("tableUpdated", object: nil, queue: mainOperationQueue) { (notification) in
            self.tableView.reloadData()
        }
    }
    
    private func configureTableColumns() {
        // Remove temporary column
        if let tableColumn = tableView.tableColumns.first {
            tableView.removeTableColumn(tableColumn)
        }
        
        // Add table properties
        for property in entity.init().propertyNames() {
            let tableColumn = NSTableColumn()
            tableColumn.title = property
            tableView.addTableColumn(tableColumn)
        }
    }
    
    // MARK: - IBActions
    
    override func rightMouseDown(theEvent: NSEvent) {
        let eventLocation = theEvent.locationInWindow
        let tableViewLocation = view.convertPoint(eventLocation, toView: tableView)
        rightClickedRow = tableView.rowAtPoint(tableViewLocation)
        
        // Show menu
        let menu = NSMenu(title: "Modify")
        menu.insertItemWithTitle("Insert", action: .insertRow, keyEquivalent: "", atIndex: 0)
        menu.insertItemWithTitle("Update", action: .updateRow, keyEquivalent: "", atIndex: 1)
        menu.insertItemWithTitle("Delete", action: .deleteRow, keyEquivalent: "", atIndex: 2)
        NSMenu.popUpContextMenu(menu, withEvent: theEvent, forView: view)
    }
    
    private func showEditWindow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        editWindowController = storyboard.instantiateControllerWithIdentifier(Constants.Identifier.editWindowController.rawValue) as? NSWindowController
        
        guard let editViewController = editWindowController?.contentViewController as? EditViewController
        else { return }
        
        editViewController.entity = entity
        
        editWindowController?.showWindow(nil)
    }
    
    func insertRow() {
        if let row = rightClickedRow {
            let entity = Database.sharedDatabase.entity(index: row)
            entity.insert()
        }
    }
    
    func updateRow() {
        if let row = rightClickedRow {
            let entity = Database.sharedDatabase.entity(index: row)
            entity.update()
        }
    }
    
    func deleteRow() {
        if let row = rightClickedRow, let element = table[row] as? Entity {
            element.delete()
        }
    }
    
}

// MARK: - Selector

private extension Selector {
    
    static let insertRow = #selector(TableViewController.insertRow)
    static let updateRow = #selector(TableViewController.updateRow)
    static let deleteRow = #selector(TableViewController.deleteRow)
    
}

// MARK: - NSTableViewDataSource

extension TableViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return table.count
    }
    
}

// MARK: - NSTableViewDelegate

extension TableViewController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Configure cell
        if let cell = tableView.makeViewWithIdentifier(TableView.Cell.identifier, owner: nil) as? NSTableCellView,
        let columnTitle = tableColumn?.title,
        let element = table[row] as? Entity
        {
            cell.textField?.stringValue = element.value(propertyName: columnTitle)
            return cell
        }
        return nil
    }
    
}