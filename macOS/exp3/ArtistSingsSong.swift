//
//  ArtistSignsSong.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class ArtistSingsSong {
    
    var artist_artistID: Int!
    var song_songID: Int!
    
}

extension ArtistSingsSong: Entity {
    
    static var tableName: String {
        return "Artist_sings_Song"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        artist_artistID = json["ARTIST_IDARTIST"].intValue
        song_songID = json["SONG_IDSONG"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(ArtistSingsSong.entityName)&methodName=deleteArtistSingsSong&firstID=\(artist_artistID)&secondID=\(song_songID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            ArtistSingsSong.table { (elements) in
                Database.sharedDatabase.artistSingsSong = elements
            }
        }
    }
    
}