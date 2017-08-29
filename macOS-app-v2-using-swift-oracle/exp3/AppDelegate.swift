//
//  AppDelegate.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        configure()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        Database.shared.connection.close()
    }

}

// MARK: - Configurable

extension AppDelegate: Configurable {
    
    class var shared: AppDelegate {
        return NSApplication.shared().delegate as! AppDelegate
    }
    
}
