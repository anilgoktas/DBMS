//
//  WebUserHasFavoriteGenre.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class WebUserHasFavoriteGenre {
    
    var webUser_webUserID: Int!
    var genre_genreID: Int!
    
}

extension WebUserHasFavoriteGenre: Entity {
    
    static var tableName: String {
        return "WebUser_has_favorite_Genre"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        webUser_webUserID = json["WEBUSER_IDWEBUSER"].intValue
        genre_genreID = json["GENRE_IDGENRE"].intValue
    }
    
    func delete() {
        let urlString = ServiceManager.URLString.sql + "?tableName=\(WebUserHasFavoriteGenre.entityName)&methodName=deleteWebUserHasFavoriteGenre&firstID=\(webUser_webUserID)&secondID=\(genre_genreID)"
        
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .JSON, headers: nil).responseJSON { (response) in
            WebUserHasFavoriteGenre.table { (elements) in
                Database.sharedDatabase.webUserHasFavoriteGenre = elements
            }
        }
    }
    
}