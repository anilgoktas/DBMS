//
//  ServiceManager.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class ServiceManager {
    
    static let sharedManager = ServiceManager()
    
    private init() {
        
    }
    
    struct URLString {
        static let webService = "http://www.anilgoktas.com/BBM473/"
        
        static let tables = URLString.webService + "tables.php"
        static let table = URLString.webService + "table.php"
        static let sql = URLString.webService + "sql.php"
    }
    
    class func tablesRequest() -> Request {
        return Alamofire.request(.GET, URLString.tables, parameters: nil, encoding: .JSON, headers: nil)
    }
    
    class func tableRequest(tableName: String) -> Request {
        let parameter = "?name=" + tableName
        return Alamofire.request(.GET, URLString.table + parameter, parameters: nil, encoding: .JSON, headers: nil)
    }

}