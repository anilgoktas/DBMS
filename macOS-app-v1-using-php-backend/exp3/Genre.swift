//
//  Genre.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Genre {
    
    var genreID: Int!
    var name: String!
    
}

extension Genre: Entity {

    convenience init(json: JSON) {
        self.init()
        
        genreID = json["IDGENRE"].intValue
        name = json["NAME"].stringValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(Genre.entityName)&id=\(genreID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            Genre.table { (elements) in
                Database.sharedDatabase.genre = elements
            }
        }
    }

}