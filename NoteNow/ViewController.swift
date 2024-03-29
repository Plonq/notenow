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
    @IBOutlet weak var shareButton: NSButton!
    
    var text = ""
    var onTextChanged: ((String) -> Void)? = nil
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        noteTextView.string = text
        
        initSettingsMenu()
        initTextView()
        initShareButton()
    }

    // MARK: Init
    
    private func initSettingsMenu() {
        let settingsMenu = NSMenu.init(title: "Test")
        settingsMenu.addItem(withTitle: "Preferences...", action: #selector(showPreferences), keyEquivalent: "")
        settingsMenu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")
        settingsButton.menu = settingsMenu
    }
    
    private func initTextView() {
        noteTextView.font = NSFont.systemFont(ofSize: 16.0)
    }
    
    private func initShareButton() {
        shareButton.sendAction(on: .leftMouseDown)
    }
    
    // MARK: NSTextViewDelegate
    
    func textDidChange(_ notification: Notification) {
        updateText()
    }

    // MARK: Actions

    @IBAction func copyToPasteboard(_ sender: Any) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(noteTextView.string, forType: .string)
    }
    
    @IBAction func clearTextView(_ sender: Any) {
        noteTextView.string = ""
        updateText()
    }
    
    @IBAction func showSettings(_ sender: Any) {
        if let event = NSApplication.shared.currentEvent {
            NSMenu.popUpContextMenu(settingsButton.menu!, with: event, for: settingsButton)
        }
    }
    
    @IBAction func shareText(_ sender: Any) {
        let shareMenu = NSSharingServicePicker(items: [text])
        shareMenu.show(relativeTo: shareButton.bounds, of: shareButton, preferredEdge: .maxY)
    }
    
    // MARK: Private functions
    
    private func updateText() {
        guard let textChangedHandler = onTextChanged else {
            fatalError("ViewController wasn't provided a closure to handle persisting the text")
        }
        
        textChangedHandler(noteTextView.string)
    }
    
    // MARK: Settings menu actions
    
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

