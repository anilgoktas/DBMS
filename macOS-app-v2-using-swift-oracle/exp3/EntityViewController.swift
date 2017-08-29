//
//  EntityViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/14/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class EntityViewController: NSViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: - Properties
    
    var editRecordWindowController: NSWindowController?
    var newRecordWindowController: NSWindowController?
    var rightClickedRow: Int?
    
    var entity = Entity(name: "Loading...") {
        didSet {
            configureView()
            tableView.reloadData()
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    
    @IBAction func insertRecord(_ sender: Any) {
        showInsertRecordWindow(forEntity: entity)
    }
    
    @IBAction func removeRecord(_ sender: Any) {
        deleteRow(row: tableView.selectedRow)
    }
    
}

// MARK: - Configurable

extension EntityViewController: Configurable {
    
    func configureView() {
        title = entity.name
        configureTableView()
    }
    
    func configureModel() {
        entity.configureModel()
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: .entityDidConfigure, name: .EntityDidConfigure, object: nil)
        NotificationCenter.default.addObserver(self, selector: .entityDidConfigure, name: .DatabaseDidConfigure, object: nil)
    }
    
    func configureTableView() {
        tableView.tableColumns.forEach { tableView.removeTableColumn($0) }
        
        for propertyName in entity.propertyNames {
            let tableColumn = NSTableColumn(identifier: TableView.Column.identifier)
            tableColumn.title = propertyName
            tableView.addTableColumn(tableColumn)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func updateRow(_ sender: Any) {
        let record = entity.records[tableView.selectedRow]
        showEditRecordWindow(entity: entity, record: record)
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        let eventLocation = theEvent.locationInWindow
        let tableViewLocation = view.convert(eventLocation, to: tableView)
        rightClickedRow = tableView.row(at: tableViewLocation)
        
        // Show menu
        let menu = NSMenu(title: "Modify")
        menu.insertItem(withTitle: "Update", action: .updateRightClickedRow, keyEquivalent: "", at: 0)
        menu.insertItem(withTitle: "Delete", action: .deleteRightClickedRow, keyEquivalent: "", at: 1)
        NSMenu.popUpContextMenu(menu, with: theEvent, for: view)
    }
    
    func entityDidConfigure() {
        tableView.reloadData()
    }
    
    func updateRightClickedRow() {
        showEditRecordWindow(entity: entity)
    }
    
    func deleteRightClickedRow() {
        deleteRow(row: rightClickedRow)
    }
    
    fileprivate func deleteRow(row: Int?) {
        guard let row = row else { return }
        
        do {
            try entity.delete(recordAtIndex: row)
            tableView.reloadData()
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
}

// MARK: - NSTableViewDataSource

extension EntityViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return entity.records.count
    }
    
}

// MARK: - NSTableViewDelegate

extension EntityViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Configure cell
        guard
        let cell = tableView.make(withIdentifier: TableView.Cell.identifier, owner: nil) as? NSTableCellView,
        let columnTitle = tableColumn?.title
        else { return nil }
        
        color(cell: cell, forColumnTitle: columnTitle)
        
        if let value = entity.records[row][columnTitle] {
            cell.textField?.stringValue = String(describing: value)
        } else {
            cell.textField?.stringValue = " "
        }
        return cell
    }
    
    fileprivate func color(cell: NSTableCellView, forColumnTitle columnTitle: String) {
        var textColor = NSColor.black
        var backgroundColor = NSColor.white
        
        cell.textField?.drawsBackground = true
        
        if entity.is(string: columnTitle, key: .primary) {
            backgroundColor = .red
            textColor = .white
        } else if entity.is(string: columnTitle, key: .foreign) {
            backgroundColor = .blue
            textColor = .white
        }
        
        cell.textField?.backgroundColor = backgroundColor
        cell.textField?.textColor = textColor
    }
    
}

// MARK: - EditRecordViewDelegate

extension EntityViewController: EditRecordViewDelegate { }

// MARK: - NewRecordViewDelegate

extension EntityViewController: NewRecordViewDelegate { }

// MARK: - Selector

fileprivate extension Selector {
    static let entityDidConfigure = #selector(EntityViewController.entityDidConfigure)
    static let updateRightClickedRow = #selector(EntityViewController.updateRightClickedRow)
    static let deleteRightClickedRow = #selector(EntityViewController.deleteRightClickedRow)
}

// MARK: - Constants

extension EntityViewController {
    
    fileprivate struct TableView {
        struct Cell {
            static let identifier = "TableCell"
        }
        struct Column {
            static let identifier = "TableColumn"
        }
    }
    
}
