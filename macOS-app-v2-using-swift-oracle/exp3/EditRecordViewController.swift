//
//  EditRecordViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/15/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

enum EditRecordError: Error {
    case emptyField
}

final class EditRecordViewController: NSViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var stackView: NSStackView!
    
    // MARK: - Properties
    
    var entity: Entity!
    var record: Record!
    var propertyViews = [PropertyView]()
    weak var delegate: EditRecordViewDelegate?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - IBActions
    
    @IBAction func updateRecord(_ sender: NSButton) {
        do {
            let filledProperties = try properties()
            try entity.update(record: record, withProperties: filledProperties)
            
            delegate?.didEditRecord()
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
}

// MARK: - Configurable

extension EditRecordViewController: Configurable {
    
    func configure(withRecord record: Record) {
        self.record = record
        
        for (index, propertyName) in record.entity.propertyNames.enumerated() {
            let isPrimaryKey = record.entity.is(string: propertyName, key: .primary)
            let isForeignKey = record.entity.is(string: propertyName, key: .foreign)
            
            guard let propertyView = PropertyView.view(owner: self) else { continue }
            propertyView.configure(withPropertyName: propertyName, propertyValue: record[propertyName], isPrimaryKey: isPrimaryKey, isForeignKey: isForeignKey)
            propertyViews.append(propertyView)
            stackView.insertView(propertyView, at: index, in: .center)
        }
    }
    
    fileprivate func properties() throws -> [Property] {
        var properties = [Property]()
        for propertyView in propertyViews {
            // Check all fields are filled.
            guard let property = propertyView.property else { throw InsertRecordError.emptyField }
            properties.append(property)
        }
        return properties
    }
    
}
