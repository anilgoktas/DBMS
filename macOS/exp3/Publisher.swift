//
//  Publisher.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Publisher {
    
    var publisherID: Int!
    var name: String!
    var address: String?
    var telephone: String?
    
}

extension Publisher: Entity {

    convenience init(json: JSON) {
        self.init()
        
        publisherID = json["IDPUBLISHER"].intValue
        name = json["NAME"].stringValue
        address = json["ADDRESS"].stringValue
        telephone = json["TELEPHONE"].stringValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(Publisher.entityName)&id=\(publisherID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            Publisher.table { (elements) in
                Database.sharedDatabase.publisher = elements
            }
        }
    }

}