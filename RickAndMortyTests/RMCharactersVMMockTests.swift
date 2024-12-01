//
//  RMCharactersVMMockTests.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//
import XCTest
@testable import RickAndMorty

class RMCharactersMockVMTests: XCTestCase {
    var viewModel: RMCharactersMockVM!

    override func setUp() {
        super.setUp()
        viewModel = RMCharactersMockVM()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testMockDataLoading() async {
        // Mock data is loaded from the file
        await viewModel.fetchCharacters(status: CharacterStatus.alive.rawValue, reset: true)
        
        // Verify that mock characters were loaded
        XCTAssertFalse(viewModel.characters.isEmpty)

        // Ensure no error occurred
        XCTAssertNil(viewModel.error)
    }
    
    func testMockPagination() async {
        // Fetch initial list
        await viewModel.fetchCharacters(status: "Alive", reset: true)
        
        let initialCharacterCount = viewModel.characters.count
        
        // Fetch the next page with same filter status
        await viewModel.fetchCharacters(status: "Alive", reset: false)
        
        // List count must increase after second fetch
        XCTAssertGreaterThan(viewModel.characters.count, initialCharacterCount)
    }
}
