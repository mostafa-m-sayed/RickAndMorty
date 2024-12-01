//
//  CharacterDetailsVC.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 01/12/2024.
//

import UIKit
import SwiftUI

final class CharacterDetailsVC: UIViewController {
    var characterDetails: RMCharacterVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    private func setupUI() {
        // Set up SwiftUI view
        guard let characterDetails else { return }

        let detailsView = CharacterDetailsView(
            characterDetails: characterDetails,
            onDismiss: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        )
        
        let hostingController = UIHostingController(rootView: detailsView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
