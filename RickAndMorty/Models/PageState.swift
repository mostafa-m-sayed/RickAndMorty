//
//  PageState.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//


enum PageState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}