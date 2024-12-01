//
//  RMCharactersVMTests.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//

import XCTest
@testable import RickAndMorty

class RMCharactersVMTests: XCTestCase {
    var viewModel: RMCharactersVM!
    
    override func setUp() {
        super.setUp()
        viewModel = RMCharactersVM()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCharactersSuccess() async {
        // Simulate a successful API call
        await viewModel.fetchCharacters(status: CharacterStatus.alive.rawValue, reset: true)
        
        // The list must be populated
        XCTAssertFalse(viewModel.characters.isEmpty)
        
        // Ensure no error occurred
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchCharactersError() async {
        // Simulate an error condition (e.g., network failure)
        //        viewModel.error = "Test Error"
        
        await viewModel.fetchCharacters(status: "wrongFilter", reset: true)
        
        // Error message is set by the BE
        XCTAssertNotNil(viewModel.error)
        
        // The list must be empty die to the error
        XCTAssertEqual(viewModel.characters, [])
        
    }
    
    func testPagination() async {
        // Initial fetch
        await viewModel.fetchCharacters(status: CharacterStatus.alive.rawValue, reset: true)
        
        let initialCharacterCount = viewModel.characters.count
        
        // Fetch the next page with the same filter without reset
        await viewModel.fetchCharacters(status: CharacterStatus.alive.rawValue, reset: false)
        
        // List count must increase after second fetch
        XCTAssertGreaterThan(viewModel.characters.count, initialCharacterCount)
    }
    
    func testResetPagination() async {
        // Initial fetch
        await viewModel.fetchCharacters(status: nil, reset: false)
        
        let firstCharacterCount = viewModel.characters.count
        
        // Fetch next page with changed filter so reset happens
        await viewModel.fetchCharacters(status: CharacterStatus.alive.rawValue, reset: false)
        
        // Check that the characters are reset
        XCTAssertEqual(viewModel.characters.count, firstCharacterCount)
    }
}
