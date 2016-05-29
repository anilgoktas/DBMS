//
//  ArtistHasGenre.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class ArtistHasGenre {
    
    var artist_artistID: Int!
    var genre_genreID: Int!
    
}

extension ArtistHasGenre: Entity {
    
    static var tableName: String {
        return "Artist_has_Genre"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        artist_artistID = json["ARTIST_IDARTIST"].intValue
        genre_genreID = json["GENRE_IDGENRE"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(ArtistHasGenre.entityName)&methodName=deleteArtistHasGenre&firstID=\(artist_artistID)&secondID=\(genre_genreID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            ArtistHasGenre.table { (elements) in
                Database.sharedDatabase.artistHasGenre = elements
            }
        }
    }
    
}