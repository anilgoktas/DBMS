//
//  NewRecordViewDelegate.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/25/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

protocol NewRecordViewDelegate: class {
    var newRecordWindowController: NSWindowController? { get set }
    var rightClickedRow: Int? { get set }
    
    func didAddNewRecord()
}

extension NewRecordViewDelegate {
    
    func showInsertRecordWindow(forEntity entity: Entity) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        newRecordWindowController = storyboard.instantiateController(withIdentifier: "NewRecordWindowController") as? NSWindowController
        
        guard let newRecordViewController = newRecordWindowController?.contentViewController as? NewRecordViewController
        else { return }
        
        newRecordViewController.delegate = self
        newRecordViewController.configure(withEntity: entity)
        newRecordWindowController?.showWindow(nil)
    }
    
    func showInsertRecordWindow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        newRecordWindowController = storyboard.instantiateController(withIdentifier: "NewRecordWindowController") as? NSWindowController
        
        guard
        let newRecordViewController = newRecordWindowController?.contentViewController as? NewRecordViewController,
        let row = rightClickedRow,
        Database.shared.entities.count > row, row >= 0
        else { return }
        
        newRecordViewController.delegate = self
        newRecordViewController.configure(withEntity: Database.shared.entities[row])
        newRecordWindowController?.showWindow(nil)
    }
    
    func didAddNewRecord() {
        newRecordWindowController?.close()
        
        // Alert success.
        let alert = NSAlert()
        alert.messageText = "Insert is successful."
        alert.runModal()
    }
    
}
