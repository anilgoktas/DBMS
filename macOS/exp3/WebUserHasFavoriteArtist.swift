//
//  WebUserHasFavoriteArtist.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class WebUserHasFavoriteArtist {
    
    var webUser_webUserID: Int!
    var artist_artistID: Int!
    
}

extension WebUserHasFavoriteArtist: Entity {
    
    static var tableName: String {
        return "WebUser_has_favorite_Artist"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        webUser_webUserID = json["WEBUSER_IDWEBUSER"].intValue
        artist_artistID = json["ARTIST_IDARTIST"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(WebUserHasFavoriteArtist.entityName)&methodName=deleteWebUserHasFavoriteArtist&firstID=\(webUser_webUserID)&secondID=\(artist_artistID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            WebUserHasFavoriteArtist.table { (elements) in
                Database.sharedDatabase.webUserHasFavoriteArtist = elements
            }
        }
    }
    
}