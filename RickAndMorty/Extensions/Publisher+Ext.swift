//
//  Publisher+Ext.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import Combine
import Foundation

extension Publisher {
    func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        self.receive(on: DispatchQueue.main)
    }
}
