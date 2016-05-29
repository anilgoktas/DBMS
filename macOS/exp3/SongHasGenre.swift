//
//  SongHasGenre.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class SongHasGenre {
    
    var song_songID: Int!
    var genre_genreID: Int!
    
}

extension SongHasGenre: Entity {
    
    static var tableName: String {
        return "Song_has_Genre"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        song_songID = json["SONG_IDSONG"].intValue
        genre_genreID = json["GENRE_IDGENRE"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(SongHasGenre.entityName)&methodName=deleteSongHasGenre&firstID=\(song_songID)&secondID=\(genre_genreID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            SongHasGenre.table { (elements) in
                Database.sharedDatabase.songHasGenre = elements
            }
        }
    }
    
}