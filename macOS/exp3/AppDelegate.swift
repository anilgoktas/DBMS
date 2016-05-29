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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        Database.sharedDatabase.configure()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

extension AppDelegate {
    
    class func sharedDelegate() -> AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
    
}