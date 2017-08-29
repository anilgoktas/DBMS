//
//  PropertyView.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class PropertyView: NSView {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var propertyKeyLabel: NSTextField!
    @IBOutlet fileprivate weak var propertyValueTextField: NSTextField!
    
    // MARK: - Properties
    
    fileprivate var key: String!
    var value: Any? { return propertyValueTextField.objectValue }
    
    var property: Property? {
        guard let value = value else { return nil }
        return Property(dict: (key: key, value: value))
    }
    
    // MARK: - Life Cycle

    override func awakeFromNib() { }
    
}

// MARK: - Configurable

extension PropertyView {
    
    func configure(withPropertyName propertyName: String, propertyValue: Any? = nil, isPrimaryKey: Bool = false, isForeignKey: Bool = false) {
        self.key = propertyName
        propertyKeyLabel.stringValue = propertyName + ": "
        propertyKeyLabel.drawsBackground = true

        var textColor = NSColor.black
        var backgroundColor = NSColor.white
        
        if isPrimaryKey {
            backgroundColor = .red
            textColor = .white
            propertyKeyLabel.stringValue = propertyName + "(PK): "
            propertyValueTextField.isEditable = false
        } else if isForeignKey {
            backgroundColor = .blue
            textColor = .white
            propertyKeyLabel.stringValue = propertyName + "(FK): "
        }
        
        propertyKeyLabel.textColor = textColor
        propertyKeyLabel.backgroundColor = backgroundColor
        layer?.drawsAsynchronously = true
        layer?.backgroundColor = backgroundColor.cgColor
        
        if let propertyValue = propertyValue {
            propertyValueTextField.stringValue = String(describing: propertyValue)
        } else if isPrimaryKey {
            propertyKeyLabel.stringValue = propertyName + "(PK): Not Editable"
        }
    }
    
    class func view(owner: Any? = nil) -> PropertyView? {
        let nibName = "PropertyView"
        
        var topLevelObjects = [Any]() as NSArray
        guard let nib = NSNib(nibNamed: nibName, bundle: Bundle.main)
        else { return nil }
        
        nib.instantiate(withOwner: owner, topLevelObjects: &topLevelObjects)
        
        for view in topLevelObjects where view is PropertyView {
            if let view = view as? PropertyView {
                return view
            }
        }
        return nil
    }
    
}
