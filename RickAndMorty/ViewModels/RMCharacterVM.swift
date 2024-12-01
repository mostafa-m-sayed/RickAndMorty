//
//  RMCharacterVM.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import Foundation

struct RMCharacterVM: Hashable {
    var character: RMCharacter

    var name: String {
        return character.name ?? ""
    }

    var species: String {
        return character.species ?? ""
    }

    var image: URL? {
        if let imageURL = character.image {
            return URL(string: imageURL)
        }
        return nil
    }
    
    var status: CharacterStatus? {
        if let status = character.status {
            return CharacterStatus(rawValue: status.lowercased())
        }
        return nil
    }

    var location: String {
        return character.location?.name ?? ""
    }
    var gender: String {
        return character.gender ?? ""
    }
}
