//
//  EntitiesViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class EntitiesViewController: NSViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: - Properties
    
    var entityWindowController: NSWindowController?
    var newRecordWindowController: NSWindowController?
    var rightClickedRow: Int?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    
    @IBAction func tableViewDidDoubleClick(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        entityWindowController = storyboard.instantiateController(withIdentifier: Constants.EntityWindowController.identifier) as? NSWindowController
        
        guard let entityViewController = entityWindowController?.contentViewController as? EntityViewController,
        Database.shared.entities.count > tableView.selectedRow, tableView.selectedRow >= 0
        else { return }
        
        entityViewController.entity = Database.shared.entities[tableView.selectedRow]
        entityWindowController?.showWindow(nil)
    }
    
    @IBAction func refreshDatabase(_ sender: Any) {
        entityWindowController?.close()
        newRecordWindowController?.close()
        
        Database.shared.configureTables()
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        let eventLocation = theEvent.locationInWindow
        let tableViewLocation = view.convert(eventLocation, to: tableView)
        rightClickedRow = tableView.row(at: tableViewLocation)
        
        // Show menu
        let menu = NSMenu(title: "Modify")
        menu.insertItem(withTitle: "Insert", action: .insertRow, keyEquivalent: "", at: 0)
        NSMenu.popUpContextMenu(menu, with: theEvent, for: view)
    }
    
}

// MARK: - Configurable

extension EntitiesViewController: Configurable {
    
    func configureView() {
        title = Database.shared.connection.conn_info.service_name
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: .databaseDidConfigure, name: .DatabaseDidConfigure, object: nil)
        NotificationCenter.default.addObserver(self, selector: .databaseDidConfigure, name: .EntityDidConfigure, object: nil)
    }
    
    func databaseDidConfigure() {
        tableView.reloadData()
    }
    
    func insertRow() {
        showInsertRecordWindow()
    }
    
}

// MARK: - NSTableViewDataSource

extension EntitiesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Database.shared.entities.count
    }
    
}

// MARK: - NSTableViewDelegate

extension EntitiesViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier: String
        let stringValue: String
        
        // Configure cellIdentifier and stringValue
        if tableColumn?.title == TableView.Column.TableName.rawValue {
            cellIdentifier = TableView.CellIdentifier.TableName.rawValue
            stringValue = Database.shared.entities[row].name
        } else {
            cellIdentifier = TableView.CellIdentifier.RowCount.rawValue
            stringValue = "\(Database.shared.entities[row].records.count)"
        }
        
        // Configure cell
        guard let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView
        else { return nil }
        
        cell.textField?.stringValue = stringValue
        return cell
    }
    
}

// MARK: - NewRecordViewDelegate

extension EntitiesViewController: NewRecordViewDelegate { }

// MARK: - Constants

extension EntitiesViewController {
    
    fileprivate struct Constants {
        fileprivate struct EntityWindowController {
            static let identifier = "EntityWindowController"
        }
        fileprivate struct NewRecordWindowController {
            static let identifier = "NewRecordWindowController"
        }
    }
    
    fileprivate struct TableView {
        fileprivate enum Column: String {
            case TableName = "Table Name"
            case RowCount = "Row Count"
        }
        
        fileprivate enum CellIdentifier: String {
            case TableName = "TableNameCell"
            case RowCount = "RowCountCell"
        }
    }
    
}

// MARK: - Selector

fileprivate extension Selector {
    static let insertRow = #selector(EntitiesViewController.insertRow)
    static let databaseDidConfigure = #selector(EntitiesViewController.databaseDidConfigure)
}
