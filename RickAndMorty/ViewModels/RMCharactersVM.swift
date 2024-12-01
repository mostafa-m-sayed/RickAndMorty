//
//  RMCharactersVM.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//
import Foundation
import Combine

protocol RMCharactersVMProtocol {
    func fetchCharacters(status: String?, reset: Bool) async
    
    var characters: [RMCharacterVM] { get set }
    var isLoading: Bool { get set }
    var error: String? { get set }
}


final class RMCharactersVM: RMCharactersVMProtocol {
    
    @Published var characters: [RMCharacterVM] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func fetchCharacters(status: String?, reset: Bool = false) async {
        
        if currentStatusFilter != status || reset {
            resetPagination()
        }
        
        guard hasMoreItems, !isLoading else { return }
        currentStatusFilter = status
        isLoading = true
        do {
            let request = try formRequest(status: status)
            let (data, response) = try await URLSession.shared.data(for: request)
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                if let message = try extractMessageFromData(data: data) {
                    self.error = message
                    return
                } else {
                    self.error = NetworkError.invalidResponse.localizedDescription
                    return
                }
            }
            do {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("data:", dataString)
                }
                let response = try JSONDecoder().decode(RMCharactersResponse.self, from: data)
                pagesCount = response.info.pages
                let newCharacters = response.results.map { RMCharacterVM(character: $0) }
                await MainActor.run {
                    if page == 1 {
                        // Resetted by pulling to refresh or changed filter
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
    
    private func formRequest(status: String?) throws -> URLRequest {
        guard let url = URL(string: Constants.baseUrl)?.appending(path: Constants.charactersEndpoint) else { throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var parameters = [URLQueryItem]()
        
        if let status = status {
            parameters.append(.init(name: "status", value: status))
        }
        if page > 0 {
            parameters.append(.init(name: "page", value: String(page)))
        }
        
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters
            request.url = components.url
        }
        return request
    }
    
    private func extractMessageFromData(data: Data) throws -> String? {
        if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return jsonDictionary["error"] as? String
        }
        return nil
    }
}
