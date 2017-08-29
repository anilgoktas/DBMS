//
//  Playlist.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Playlist {
    
    var name: String!
    var webUser_webUserID: Int!
    var song_songID: Int!
    
}

extension Playlist: Entity {

    convenience init(json: JSON) {
        self.init()
        
        name = json["NAME"].stringValue
        webUser_webUserID = json["WEBUSER_IDWEBUSER"].intValue
        song_songID = json["SONG_IDSONG"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(Playlist.entityName)&methodName=deletePlaylist&firstID=\(webUser_webUserID)&secondID=\(song_songID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            Playlist.table { (elements) in
                Database.sharedDatabase.playlist = elements
            }
        }
    }

}