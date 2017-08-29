//
//  Property.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Property {
    
    // MARK: - Properties
    
    let key: String
    let value: Any
    
    var stringValue: String {
        guard let stringValue = value as? String
        else { return String(describing: value) }
        
        guard let intValue = Int(stringValue)
        else { return "'" + stringValue + "'" }
        
        return String(describing: intValue)
    }
    
    // MARK: - Life Cycle
    
    init(dict: (key: String, value: Any?)) {
        self.key = dict.key
        self.value = dict.value ?? " "
    }
    
}
