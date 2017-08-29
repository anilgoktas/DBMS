//
//  Song.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Song {
    
    var songID: Int!
    var name: String!
    var rating = 0
    
}

extension Song: Entity {

    convenience init(json: JSON) {
        self.init()
        
        songID = json["IDSONG"].intValue
        name = json["NAME"].stringValue
        rating = json["RATING"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?methodName=delete\(Song.entityName)&id=\(songID)"
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            print(response)
            
            Song.table { (elements) in
                Database.sharedDatabase.song = elements
            }
        }
    }
    
}