//
//  AppDelegate.swift
//  NoteNow
//
//  Created by Huon Imberger on 8/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: Properties
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var textStorage = ""
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "⦿"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(show)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func show() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("Unable to find ViewController in the storyboard")
        }
        
        guard let button = statusItem.button else {
            fatalError("Unable to find button on statusItem")
        }
        
        vc.textChangedCallback = updateText
        vc.text = textStorage
        
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
    }
    
    func updateText(_ string: String) {
        textStorage = string
    }
}

