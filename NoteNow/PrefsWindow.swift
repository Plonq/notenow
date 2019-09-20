//
//  PrefsWindow.swift
//  NoteNow
//
//  Created by Huon Imberger on 20/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import Cocoa

class PrefsWindow: NSWindow {

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        if let vc = self.contentViewController as? PrefsViewController {
            if vc.listening {
                vc.updateGlobalShortcut(event)
            }
        }
    }
}
