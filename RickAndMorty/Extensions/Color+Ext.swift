//
//  Color+Ext.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//

import SwiftUI

extension Color {
    static var appPurple: Color {
        Color(hex: "#504974")
    }
    static var lightPurple: Color {
        Color(hex: "#827C9C")
    }
    static var darkPurple: Color {
        Color(hex: "#170341")
    }
    static var skyBlue: Color {
        Color(hex: "#61CBF4")
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (no alpha)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}