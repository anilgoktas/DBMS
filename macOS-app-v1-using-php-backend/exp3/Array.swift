//
//  Array.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

extension Array where Element: Entity {
    
    mutating func configure() {
        ServiceManager.tableRequest(Element.entityName).responseJSON { (response) in
            guard let tableDicts = response.result.value else { return }
            
            // Remove all whether connection is successful
            self.removeAll()
            
            // Append new elements
            let tablesJSON = JSON(tableDicts)
            for tableJSON in tablesJSON.arrayValue {
                self.append(Element(json: tableJSON))
            }
            
            // Post notification for observers
            notificationCenter.postNotificationName("tableUpdated", object: nil)
            notificationCenter.postNotificationName(Element.entityName + "/updated", object: nil)
        }
    }
    
}