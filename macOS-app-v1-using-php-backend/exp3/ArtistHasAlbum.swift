//
//  ArtistHasAlbum.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class ArtistHasAlbum {
    
    var artist_artistID: Int!
    var album_albumID: Int!
    
}

extension ArtistHasAlbum: Entity {
    
    static var tableName: String {
        return "Artist_has_Album"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        artist_artistID = json["ARTIST_IDARTIST"].intValue
        album_albumID = json["ALBUM_IDALBUM"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(ArtistHasAlbum.entityName)&methodName=deleteArtistHasAlbum&firstID=\(artist_artistID)&secondID=\(album_albumID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            ArtistHasAlbum.table { (elements) in
                Database.sharedDatabase.artistHasAlbum = elements
            }
        }
    }
    
}