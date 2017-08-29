//
//  Entity.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/22/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

enum EntityKey: String {
    case primary = "P"
    case foreign = "R"
}

final class Entity {
    
    // MARK: - Properties
    
    let name: String
    fileprivate(set) var primaryKeys = [String]()
    fileprivate(set) var foreignKeys = [String]()
    fileprivate(set) var propertyNames = [String]()
    fileprivate(set) var records = [Record]()
    
    // MARK: - Life Cycle
    
    init(name: String) {
        self.name = name
        
        do {
            guard name != "Loading..." else { return }
            let cursor = try Database.shared.connection.cursor()
            try cursor.execute("SELECT column_name FROM user_tab_cols WHERE table_name = '" + name + "'")
            propertyNames = cursor.flatMap { $0.list.first }.flatMap { $0 as? String }
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
}

// MARK: - Configurable

extension Entity: Configurable {
    
    func configureModel() {
        do {
            guard name != "Loading..." else { return }
            let cursor = try Database.shared.connection.cursor()
            try cursor.execute("SELECT * FROM " + name)
            
            let newRecords = cursor.flatMap { Record(entity: self, row: $0) }
            
            newRecords.filter { newRecord in
                records.filter {
                    if (newRecord.recordID == $0.recordID) {
                        $0.row = newRecord.row
                        return true
                    }
                    return false
                }.count == 0
            }.forEach { records.append($0) }
            
            DispatchQueue.main.async { [weak self] in
                NotificationCenter.default.post(name: .DatabaseDidConfigure, object: nil)
                NotificationCenter.default.post(name: .EntityDidConfigure, object: self)
            }
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
    func configureKeys() {
        let sqlCommand = "SELECT cols.column_name, cons.constraint_type "
        + "FROM all_constraints cons, all_cons_columns cols "
        + "WHERE cols.table_name = '" + name + "' "
        + "AND (cons.constraint_type = 'P' OR cons.constraint_type = 'R') "
        + "AND cons.constraint_name = cols.constraint_name "
        + "AND cons.owner = cols.owner"
        
        do {
            let cursor = try Database.shared.connection.cursor()
            try cursor.execute(sqlCommand)
            
            for row in cursor {
                guard
                let constraintType = row.dict["CONSTRAINT_TYPE"] as? String,
                let key = EntityKey(rawValue: constraintType),
                let columnName = row.dict["COLUMN_NAME"] as? String
                else { continue }
                
                switch key {
                case .primary: primaryKeys.append(columnName)
                case .foreign: foreignKeys.append(columnName)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                NotificationCenter.default.post(name: .DatabaseDidConfigure, object: nil)
                NotificationCenter.default.post(name: .EntityDidConfigure, object: self)
            }
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
    func `is`(string: String, key: EntityKey) -> Bool {
        switch key {
        case .primary: return primaryKeys.contains(string)
        case .foreign: return foreignKeys.contains(string)
        }
    }
    
}

// MARK: - SQL

extension Entity {
    
    func insertRecord(withProperties properties: [Property]) throws {
        var sqlCommand = "INSERT INTO " + name + " ("

        // List parameters.
        for (index, property) in properties.enumerated() {
            sqlCommand += property.key
            if index < properties.count-1 { sqlCommand += ", " }
        }
        
        // List values.
        sqlCommand += ") VALUES ("
        for (index, property) in properties.enumerated() {
            if let stringValue = property.value as? String {
                if let intValue = Int(stringValue) {
                    sqlCommand += String(describing: intValue)
                } else {
                    sqlCommand += "'" + stringValue + "'"
                }
            } else {
                sqlCommand += String(describing: property.value)
            }
            if index < properties.count-1 { sqlCommand += ", " }
        }
        sqlCommand += ")"
        
        // Execute
        let cursor = try Database.shared.connection.cursor()
        try cursor.execute(sqlCommand)
        
        configureModel()
    }
    
    func update(record: Record, withProperties properties: [Property]) throws {
        var sqlCommand = "UPDATE " + name + " SET "
        
        // List parameters.
        for (index, property) in properties.enumerated() {
            // Do not add to parameters if primary key
            if self.is(string: property.key, key: .primary) { continue }
            
            // Add key.
            sqlCommand += property.key + "=" + property.stringValue
            
            if index < properties.count-1 { sqlCommand += ", " }
        }
        sqlCommand += " WHERE " + record.matchingClause(forKey: .primary)
        
        // Execute
        let cursor = try Database.shared.connection.cursor()
        try cursor.execute(sqlCommand)
        
        configureModel()
    }
    
    func delete(recordAtIndex index: Int) throws {
        let record = records[index]
        let sqlCommand = "DELETE FROM " + name + " WHERE " + record.matchingClauses
        
        // Execute
        let cursor = try Database.shared.connection.cursor()
        try cursor.execute(sqlCommand)
        
        records.remove(at: index)
        
        NotificationCenter.default.post(name: .RecordDidConfigure, object: nil)
        NotificationCenter.default.post(name: .EntityDidConfigure, object: nil)
        NotificationCenter.default.post(name: .DatabaseDidConfigure, object: nil)
    }
    
}

// MARK: - Equatable

extension Entity: Equatable {
    
    public static func ==(lhs: Entity, rhs: Entity) -> Bool {
        return lhs.name == rhs.name
    }
    
}

// MARK: - Notification.Name

extension Notification.Name {
    static let EntityDidConfigure = Notification.Name(rawValue: "EntityDidConfigure")
}
