//
//  Database.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class Database {
    
    // MARK: - Singleton
    
    static fileprivate(set) var shared: Database!
    
    // MARK: - Properties
    
    let connection: Connection
    
    // MARK: - Tables
    
    fileprivate(set) var entities = [Entity]()
    
    // MARK: - Life Cycle
    
    fileprivate init() {
        let service = OracleService(host: "bbm473exp3.cwiurydvwqm6.eu-central-1.rds.amazonaws.com", port: "1521", service: "ORCL")
        connection = Connection(service: service, user:"anilgoktas", pwd:"")
        
        try! connection.open()
        connection.autocommit = true
    }
    
    fileprivate init(connection: Connection) {
        self.connection = connection
    }
    
    class func login(host: String, port: String = "1521", service: String = "ORCL", user: String, password: String) throws {
        let service = OracleService(host: host, port: port, service: service)
        let connection = Connection(service: service, user: user, pwd: password)
        
        try connection.open()
        connection.autocommit = true
        
        Database.shared = Database(connection: connection)
    }
    
    // MARK: - Configurable
    
    func configureTables() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else { return }
            
            do {
                let cursor = try weakSelf.connection.cursor()
                try cursor.execute("SELECT table_name FROM user_tables")
                
                // Map table names and configure tables.
                weakSelf.entities = cursor.flatMap { $0.dict["TABLE_NAME"] as? String }.map { Entity(name: $0) }
                
                weakSelf.entities.forEach { $0.configure() }
                weakSelf.entities.forEach { $0.configureKeys() }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .DatabaseDidConfigure, object: nil)
                    print("All Done!")
                }
            } catch {
                DispatchQueue.main.async {
                    NSAlert(error: error).runModal()
                }
            }
        }
    }
    
}

// MARK: - Notification.Name

extension Notification.Name {
    static let DatabaseDidConfigure = Notification.Name(rawValue: "DatabaseDidConfigure")
}
