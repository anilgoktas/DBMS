//
//  Record.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/22/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class Record {
    
    // MARK: - Properties
    
    let entity: Entity
    let recordID: Int
    var row: Row {
        didSet { properties = row.dict.map { Property(dict: $0) } }
    }
    fileprivate(set) var properties = [Property]()
    
    // MARK: - Life Cycle
    
    init?(entity: Entity, row: Row) {
        guard row.list.count > 1 else { return nil }
        guard let recordID = row.list.first as? Int else { return nil }
        
        self.entity = entity
        self.row = row
        self.recordID = recordID
        properties = row.dict.map { Property(dict: $0) }
    }
    
}

// MARK: - Subscript

extension Record {
    
    subscript(name: String) -> Any? {
        guard let optionalValue = row.dict[name], let value = optionalValue
        else { return nil }
        return value
    }
    
    subscript(key: EntityKey) -> [Property] {
        let keyArray: [String]
        switch key {
        case .primary: keyArray = entity.primaryKeys
        case .foreign: keyArray = entity.foreignKeys
        }
        return properties.filter { keyArray.contains($0.key) }
    }
    
}

// MARK: - SQL

extension Record {
    
    var matchingClauses: String {
        var matchingClause = ""
        let primaryKeyProperties = self[.primary]
        let foreignKeyProperties = self[.foreign]
        var didAddPrimaryKeyProperty = false
        
        for (index, primaryKeyProperty) in primaryKeyProperties.enumerated() {
            if index > 0 { matchingClause += " AND " }
            matchingClause += primaryKeyProperty.key + " = " + String(describing: primaryKeyProperty.value)
            didAddPrimaryKeyProperty = true
        }
        
        for (index, foreignKeyProperty) in foreignKeyProperties.enumerated() {
            if didAddPrimaryKeyProperty || (index > 0) { matchingClause += " AND " }
            matchingClause += foreignKeyProperty.key + " = " + String(describing: foreignKeyProperty.value)
        }
        return matchingClause
    }
    
    func matchingClause(forKey key: EntityKey) -> String {
        var matchingClause = ""
        
        let keyProperties = self[key]
        for (index, keyProperty) in keyProperties.enumerated() {
            if index > 0 { matchingClause += " AND " }
            matchingClause += keyProperty.key + " = " + String(describing: keyProperty.value)
        }
        return matchingClause
    }
    
}

// MARK: - Notification.Name

extension Notification.Name {
    static let RecordDidConfigure = Notification.Name(rawValue: "RecordDidConfigure")
}
