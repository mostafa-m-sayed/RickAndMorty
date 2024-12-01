//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

struct RMCharacter: Hashable, Codable {
    let id: Int
    let name: String?
    let status: String?
    let species: String?
    let gender: String?
    let location: RMLocation?
    let image: String?
}

enum CharacterStatus: String, CaseIterable {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    
    var statusColor: String {
        switch self {
        case .alive: return "FFFFFF"
        case .dead: return "FBE7EB"
        case .unknown: return "EBF6FB"
        }
    }
    
    var statusText: String {
        switch self {
        case .alive: return "Alive"
        case .dead: return "Dead"
        case .unknown: return "Unknown"
        }
    }
    
    
}

