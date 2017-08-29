//
//  EditRecordViewDelegate.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/25/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

protocol EditRecordViewDelegate: class {
    var editRecordWindowController: NSWindowController? { get set }
    var rightClickedRow: Int? { get set }
    
    func didEditRecord()
}

extension EditRecordViewDelegate {
    
    func showEditRecordWindow(entity: Entity, record: Record) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        editRecordWindowController = storyboard.instantiateController(withIdentifier: "EditRecordWindowController") as? NSWindowController
        
        guard let editRecordViewController = editRecordWindowController?.contentViewController as? EditRecordViewController
        else { return }
        
        editRecordViewController.entity = entity
        editRecordViewController.delegate = self
        editRecordViewController.configure(withRecord: record)
        editRecordWindowController?.showWindow(nil)
    }
    
    func showEditRecordWindow(entity: Entity) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        editRecordWindowController = storyboard.instantiateController(withIdentifier: "EditRecordWindowController") as? NSWindowController
        
        guard
        let editRecordViewController = editRecordWindowController?.contentViewController as? EditRecordViewController,
        let row = rightClickedRow, row >= 0
        else { return }
        
        editRecordViewController.entity = entity
        editRecordViewController.delegate = self
        editRecordViewController.configure(withRecord: entity.records[row])
        editRecordWindowController?.showWindow(nil)
    }
    
    func didEditRecord() {
        editRecordWindowController?.close()
        
        // Alert success.
        let alert = NSAlert()
        alert.messageText = "Update is successful."
        alert.runModal()
    }
    
}
