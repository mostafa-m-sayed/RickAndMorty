//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//


enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError(String)
    case serverError(String)
}
