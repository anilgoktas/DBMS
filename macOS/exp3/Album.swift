//
//  Album.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Album {
    
    var albumID: Int!
    var name: String!
    var rating = 0
    var year = 0
    var publisher_publisherID: Int!
    
}

extension Album: Entity {

    convenience init(json: JSON) {
        self.init()
        
        albumID = json["IDALBUM"].intValue
        name = json["NAME"].stringValue
        rating = json["RATING"].intValue
        year = json["YEAR"].intValue
        publisher_publisherID = json["PUBLISHER_IDPUBLISHER"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(Album.entityName)&id=\(albumID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            Album.table { (elements) in
                Database.sharedDatabase.album = elements
            }
        }
    }

}