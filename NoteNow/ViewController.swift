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
    
    var text = ""
    var textChangedCallback: ((String) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        noteTextView.string = text
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK NSTextViewDelegate Methods
    
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
}

