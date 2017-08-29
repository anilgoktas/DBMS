//
//  LoginViewController.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/23/17.
//  Copyright © 2017 Anıl Göktaş. All rights reserved.
//

import Cocoa

final class LoginViewController: NSViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var hostTextField: NSTextField!
    @IBOutlet fileprivate weak var portTextField: NSTextField!
    @IBOutlet fileprivate weak var serviceTextField: NSTextField!
    @IBOutlet fileprivate weak var usernameTextField: NSTextField!
    @IBOutlet fileprivate weak var passwordTextField: NSSecureTextField!
    
    // MARK: - Properties
    
    var entitiesWindowController: NSWindowController?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func login(_ sender: Any) {
        login()
    }
    
}

// MARK: - Configurable

extension LoginViewController: Configurable {
    
    func configureView() {
        let defaults = NSUserDefaultsController.shared().defaults
        hostTextField.stringValue = defaults.string(forKey: "host") ?? ""
        portTextField.stringValue = defaults.string(forKey: "port") ?? ""
        serviceTextField.stringValue = defaults.string(forKey: "service") ?? ""
        usernameTextField.stringValue = defaults.string(forKey: "username") ?? ""
        passwordTextField.stringValue = defaults.string(forKey: "password") ?? ""
    }
    
    func saveInfo() {
        let defaults = NSUserDefaultsController.shared().defaults
        defaults.set(host, forKey: "host")
        defaults.set(port, forKey: "port")
        defaults.set(service, forKey: "service")
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
        defaults.synchronize()
    }
    
}

// MARK: - Login 

extension LoginViewController {
    
    fileprivate var host: String { return hostTextField.stringValue }
    fileprivate var port: String { return portTextField.stringValue }
    fileprivate var service: String { return serviceTextField.stringValue }
    fileprivate var username: String { return usernameTextField.stringValue }
    fileprivate var password: String { return passwordTextField.stringValue }
    
    fileprivate func login() {
        do {
            try Database.login(host: host, port: port, service: service, user: username, password: password)
            
            saveInfo()
            
            Database.shared.configureTables()
            
            NSApplication.shared().mainWindow?.close()
            showEntitiesWindow()
        } catch {
            NSAlert(error: error).runModal()
        }
    }
    
    fileprivate func showEntitiesWindow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        entitiesWindowController = storyboard.instantiateController(withIdentifier: Constants.EntitiesWindowController.identifier) as? NSWindowController
        entitiesWindowController?.showWindow(nil)
    }
    
}

// MARK: - Constants

extension LoginViewController {
    
    fileprivate struct Constants {
        fileprivate struct EntitiesWindowController {
            static let identifier = "EntitiesWindowController"
        }
    }
    
}
