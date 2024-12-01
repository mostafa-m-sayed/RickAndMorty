//
//  RMCharactersResponse.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

struct RMCharactersResponse: Codable {
    let results: [RMCharacter]
    let info: Info
}
