//
//  PrefsWindowController.swift
//  NoteNow
//
//  Created by Huon Imberger on 15/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import Cocoa

class PrefsWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
