//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import XCTest

final class RickAndMortyUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testOpenDetails() throws {
        app.launch()
        
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first table cell did not appear in time.")
        
        firstCell.tap()
        
        // Verify that the details page is presented
        let detailsView = app.otherElements["CharacterDetailsVC"]
        XCTAssertTrue(detailsView.waitForExistence(timeout: 5), "The details view did not appear after tapping a table cell.")
    }

    @MainActor
    func testTapOnFilter() throws {
        app.launch()
        
        let firstCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "The first collection cell did not appear in time.")
        
        firstCell.tap()
        let blueCell = app.collectionViews.cells["cell_blue"]
        XCTAssertTrue(blueCell.waitForExistence(timeout: 5), "The cell didnt turn blue after tapping it.")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
