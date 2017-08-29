//
//  Artist.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Artist {
    
    var artistID: Int!
    var name: String!
    var birthDate: String!
    
}

extension Artist: Entity {

    convenience init(json: JSON) {
        self.init()
        
        artistID = json["IDARTIST"].intValue
        name = json["NAME"].stringValue
        birthDate = json["BIRTHDATE"].stringValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(Artist.entityName)&id=\(artistID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            Artist.table { (elements) in
                Database.sharedDatabase.artist = elements
            }
        }

    }

}