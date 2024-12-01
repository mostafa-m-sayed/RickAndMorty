//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//
import SwiftUI

struct CharacterDetailsView: View {
    let characterDetails: RMCharacterVM
    let onDismiss: () -> Void // Closure to handle dismissing the parent UIViewController

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    // Image handling
                    AsyncImage(url: characterDetails.image) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .overlay(ProgressView(), alignment: .center)
                    }
                    .frame(height: 400)
                    .cornerRadius(25)
                    VStack {
                        HStack {
                            Button(action: {
                                onDismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Circle().fill(Color.white))
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 50)
                        Spacer()
                    }
                }
                
                // Character Info
                VStack(alignment: .leading, spacing: 8) {
                    // Title and Status
                    HStack {
                        Text(characterDetails.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        Text(characterDetails.status?.statusText ?? "")
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
//                            .padding(8)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.skyBlue)
                            .clipShape(Capsule())
                    }
                    // Species and Gender
                    HStack {
                        Text(characterDetails.species)
                            .foregroundStyle(Color.appPurple)
                            .fontWeight(.semibold)
                        Color(.black)
                            .frame(width: 5,height: 5)
                            .clipShape(.circle)
                        Text(characterDetails.gender)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.lightPurple)
                    }
                    // Location
                    HStack {
                        Text("Location :")
                            .foregroundStyle(Color.black)
                            .fontWeight(.semibold)
                        Text(characterDetails.location)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.appPurple)
                    }
                    .padding(.top)
                    
                }
                .padding(.horizontal)
            }
        }
        .edgesIgnoringSafeArea(.top) // Allow the image to extend into the safe area
    }
}
