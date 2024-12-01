//
//  Untitled.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import SwiftUI

struct RMCharacterView: View {
    let character: RMCharacterVM
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: character.image) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
                case .failure:
                    Image(systemName: Constants.defaultImageName)
                        .resizable()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
                @unknown default:
                    EmptyView()
                }
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 5) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()

            }
            .padding(.top)
            Spacer()
        }
        .frame(height: 110)
        .padding(.leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: character.status?.statusColor ?? "#FFFFFF"))
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private struct Constants {
        static let imageSize: CGFloat = 80
        static let imageCornerRadius: CGFloat = 8
        static let defaultImageName: String = "person.crop.square.fill"
    }
}

#Preview {
    let characters = [
        RMCharacterVM(character: RMCharacter(id: 1, name: "Rick", status: "Alive", species: "Human", gender: "Male", location: RMLocation(name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
    ]
    RMCharacterView(character: characters[0])
}
