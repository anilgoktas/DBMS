//
//  NewRecordViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

enum InsertRecordError: Error {
    case emptyField
}

final class NewRecordViewController: NSViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var stackView: NSStackView!
    
    // MARK: - Properties
    
    fileprivate var entity: Entity!
    var propertyViews = [PropertyView]()
    weak var delegate: NewRecordViewDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - IBActions
    
    @IBAction func insertRecord(_ sender: NSButton) {
        insertRecord()
    }
    
    func insertRecord() {
        do {
            let filledProperties = try properties()
            try entity.insertRecord(withProperties: filledProperties)
            
            delegate?.didAddNewRecord()
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
}

// MARK: - Configurable

extension NewRecordViewController: Configurable {
    
    func configure(withEntity entity: Entity) {
        self.entity = entity
        
        for (index, propertyName) in entity.propertyNames.enumerated() {
            let isPrimaryKey = entity.is(string: propertyName, key: .primary)
            let isForeignKey = entity.is(string: propertyName, key: .foreign)
            
            guard let propertyView = PropertyView.view(owner: self) else { continue }
            propertyView.configure(withPropertyName: propertyName, isPrimaryKey: isPrimaryKey, isForeignKey: isForeignKey)
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
