//
//  Table.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol Entity {
    
    static var entityName: String { get }
    
    init()
    init(json: JSON)
    func propertyNames() -> [String]
    func value(propertyName propertyName: String) -> String
    
    func delete()
    
}

extension Entity {
    
    static var entityName: String {
        return String(self)
    }
    
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
    }
    
    func value(propertyName propertyName: String) -> String {
        let filteredValues = Mirror(reflecting: self).children.filter { $0.label == propertyName }
        if let value = filteredValues.first?.value {
            return "\(value)"
        }
        return ""
    }
    
    func delete() {
        
    }
    
    static func insert() {
    }

    static func update() {
        
    }
    
    static func table(completion: (elements: [Self]) -> Void) {
        var elements = [Self]()
        
        ServiceManager.tableRequest(entityName).responseJSON { (response) in
            guard let tableDicts = response.result.value else {
                completion(elements: elements)
                return
            }
            
            // Append new elements
            let tablesJSON = JSON(tableDicts)
            for tableJSON in tablesJSON.arrayValue {
                elements.append(Self(json: tableJSON))
            }
            
            // Post notification for observers
            completion(elements: elements)
            notificationCenter.postNotificationName("tableUpdated", object: nil)
            notificationCenter.postNotificationName(Self.entityName + "/updated", object: nil)
        }
    }
    
}