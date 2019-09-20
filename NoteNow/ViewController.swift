//
//  ViewController.swift
//  NoteNow
//
//  Created by Huon Imberger on 8/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {
    // MARK: Properties
    
    @IBOutlet var noteTextView: NSTextView!
    @IBOutlet weak var settingsButton: NSButton!
    
    var text = ""
    var textChangedCallback: ((String) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        noteTextView.string = text
        
        self.initSettingsMenu()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Init Functions
    
    private func initSettingsMenu() {
        let settingsMenu = NSMenu.init(title: "Test")
        settingsMenu.addItem(withTitle: "Preferences...", action: #selector(showPreferences), keyEquivalent: "")
        settingsMenu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")
        settingsButton.menu = settingsMenu
    }
    
    // MARK NSTextViewDelegate Functions
    
    func textDidChange(_ notification: Notification) {
        guard let callback = textChangedCallback else {
            fatalError("ViewController wasn't provided a callback to update the text")
        }
        
        callback(noteTextView.string)
    }

    // MARK: Actions

    @IBAction func copyToPasteboard(_ sender: Any) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(noteTextView.string, forType: .string)
    }
    
    @IBAction func clearTextView(_ sender: Any) {
        noteTextView.string = ""
    }
    
    @IBAction func showSettings(_ sender: NSButton) {
        if let event = NSApplication.shared.currentEvent {
            NSMenu.popUpContextMenu(sender.menu!, with: event, for: sender)
        }
    }
    
    // MARK: Menu Actions
    
    @objc func showPreferences() {
        // Check if prefs window is already open. If it is, bring it to front
        var existingWindow = false
        NSApplication.shared.windows.forEach({ (window) in
            if let value = window.identifier?.rawValue {
                if value == "PrefsWindow" {
                    print("woo")
                    window.makeKeyAndOrderFront(self)
                    existingWindow = true
                }
            }
        })
        
        if existingWindow == false {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            
            guard let wc = storyboard.instantiateController(withIdentifier: "WindowController") as? NSWindowController else {
                fatalError("Unable to find WindowController in the storyboard")
            }
            
            wc.showWindow(self)
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}

