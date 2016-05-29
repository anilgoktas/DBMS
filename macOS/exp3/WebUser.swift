//
//  WebUser.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class WebUser {
    
    var webUserID: Int!
    var nickname: String!
    var password: String!
    
}

extension WebUser: Entity {

    convenience init(json: JSON) {
        self.init()
        
        webUserID = json["IDWEBUSER"].intValue
        nickname = json["NICKNAME"].stringValue
        password = json["PASSWORD"].stringValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(WebUser.entityName)&id=\(webUserID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            WebUser.table { (elements) in
                Database.sharedDatabase.webUser = elements
            }
        }
    }
    
}