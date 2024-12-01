//
//  RMCharactersMockVM.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//
import Foundation

class RMCharactersMockVM: RMCharactersVMProtocol {
    var characters: [RMCharacterVM] = []
    var isLoading: Bool = false
    var error: String?
    
    private var page: Int = 1
    private var pagesCount: Int? = nil
    private var currentStatusFilter: String? = nil
    
    private var hasMoreItems: Bool {
        return (page < pagesCount ?? 0) || pagesCount == nil
    }
    
    private func resetPagination() {
        page = 1
        pagesCount = nil
        characters.removeAll()
        error = nil
    }

    func fetchCharacters(status: String?, reset: Bool) async {
        guard let url = Bundle.main.url(forResource: "CharactersMock", withExtension: "json") else {
            print("Failed to locate mockData.json in bundle.")
            return
        }
        
        if currentStatusFilter != status || reset {
            resetPagination()
        }
        
        guard hasMoreItems, !isLoading else { return }
        currentStatusFilter = status
        isLoading = true
        do {
            let data = try Data(contentsOf: url)
            isLoading = false
            do {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("data:", dataString)
                }
                let response = try JSONDecoder().decode(RMCharactersResponse.self, from: data)
                pagesCount = response.info.pages
                let newCharacters = response.results.map { RMCharacterVM(character: $0) }
                await MainActor.run {
                    if page == 1 {
                        self.characters = newCharacters
                    } else {
                        self.characters.append(contentsOf: newCharacters)
                    }
                    page += 1
                }
                
            } catch {
                self.error = "Unable to decode response"
            }
        }
        catch {
            self.error = error.localizedDescription
        }
    }
    
}
