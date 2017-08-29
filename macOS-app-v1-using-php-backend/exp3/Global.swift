//
//  Global.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

// MARK: - Global Variables

let userDefaults       = NSUserDefaults.standardUserDefaults()
let iCloudDefaults     = NSUbiquitousKeyValueStore.defaultStore()
let notificationCenter = NSNotificationCenter.defaultCenter()
let mainOperationQueue = NSOperationQueue.mainQueue()
let application        = NSApplication.sharedApplication()
let appDelegate        = AppDelegate.sharedDelegate()
let mainBundle         = NSBundle.mainBundle()