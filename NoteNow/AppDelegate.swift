//
//  AppDelegate.swift
//  NoteNow
//
//  Created by Huon Imberger on 8/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import Cocoa
import HotKey
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Properties
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var text = ""

    public var hotKey: HotKey? {
        didSet {
            guard let hotKey = hotKey else {
                return
            }
            
            hotKey.keyDownHandler = { [weak self] in
                self?.show()
            }
        }
    }
    
    // MARK: App lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "❖"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(show)
        
        // Load saved text if it exists
        if Storage.fileExists("data.json", in: .documents) {
            let data = Storage.retrieve("data.json", from: .documents, as: AppData.self)
            text = data.text
        }
        
        // Initialise global hotkey
        if Storage.fileExists("globalKeybind.json", in: .documents) {
            let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: GlobalKeybindPreferences.self)
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: globalKeybinds.keyCode, carbonModifiers: globalKeybinds.carbonFlags))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Save text to storage
        if Storage.fileExists("data.json", in: .documents) {
            Storage.remove("data.json", from: .documents)
        }
        
        let data = AppData.init(text: text)
        Storage.store(data, to: .documents, as: "data.json")
    }
    
    // MARK: App

    @objc private func show() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Unable to find ViewController in the storyboard")
        }
        
        guard let button = statusItem.button else {
            fatalError("Unable to find button on statusItem")
        }
        
        vc.onTextChanged = { [weak self] (text) in
            self?.text = text
        }
        vc.text = text
        
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
}

