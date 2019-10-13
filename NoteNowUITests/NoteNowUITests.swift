//
//  NoteNowUITests.swift
//  NoteNowUITests
//
//  Created by Huon Imberger on 21/9/19.
//  Copyright © 2019 Huon Imberger. All rights reserved.
//

import XCTest
@testable import NoteNow

class NoteNowUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTextIsVisibleInNoteField() {
        // TODO: Implement
    }

}
