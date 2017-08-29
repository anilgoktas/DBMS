//
//  AlbumHasSong.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class AlbumHasSong {
    
    var album_albumID: Int!
    var song_songID: Int!
    
}

extension AlbumHasSong: Entity {
    
    static var tableName: String {
        return "Album_has_Song"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        album_albumID = json["ALBUM_IDALBUM"].intValue
        song_songID = json["SONG_IDSONG"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(AlbumHasSong.entityName)&methodName=deleteAlbumHasSong&firstID=\(album_albumID)&secondID=\(song_songID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            AlbumHasSong.table { (elements) in
                Database.sharedDatabase.albumHasSong = elements
            }
        }
    }
    
}