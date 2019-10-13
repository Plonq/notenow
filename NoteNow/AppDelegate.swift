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
    
    static let STORAGE_DATA = "data.json"
    static let STORAGE_GLOBAL_HOTKEY = "globalHotkey.json"
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
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
    
    // MARK: Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initStatusItem()
        loadConfigAndData()
        
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            text = "This is a test note"
        }
        #endif
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        saveData()
    }
    
    // MARK: Private functions
    
    private func initStatusItem() {
        statusItem.button?.title = "❖"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(show)
    }
    
    private func loadConfigAndData() {
        // The app data (currently just the note text)
        if Storage.fileExists(AppDelegate.STORAGE_DATA, in: .documents) {
            let data = Storage.retrieve(AppDelegate.STORAGE_DATA, from: .documents, as: AppData.self)
            text = data.text
        }
        
        // Initialise global hotkey
        if Storage.fileExists(AppDelegate.STORAGE_GLOBAL_HOTKEY, in: .documents) {
            let globalKeybinds = Storage.retrieve(AppDelegate.STORAGE_GLOBAL_HOTKEY, from: .documents, as: GlobalKeybindPreferences.self)
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: globalKeybinds.keyCode, carbonModifiers: globalKeybinds.carbonFlags))
        }
    }
    
    private func saveData() {
        if Storage.fileExists(AppDelegate.STORAGE_DATA, in: .documents) {
            Storage.remove(AppDelegate.STORAGE_DATA, from: .documents)
        }
        
        let data = AppData.init(text: text)
        Storage.store(data, to: .documents, as: AppDelegate.STORAGE_DATA)
    }

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

