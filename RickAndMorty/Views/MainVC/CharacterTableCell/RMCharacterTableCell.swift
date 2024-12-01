//
//  RMCharacterTableCell.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//
import UIKit
import SwiftUI

class RMCharacterTableCell: UITableViewCell {
    static let reuseIdentifier = "RMCharacterTableCell"

    private var hostingController: UIHostingController<RMCharacterView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: RMCharacterVM) {
        if hostingController == nil {
            let userCell = RMCharacterView(character: character)
            let hostingController = UIHostingController(rootView: userCell)
            hostingController.view.backgroundColor = .clear
            self.hostingController = hostingController
            contentView.addSubview(hostingController.view)

            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            hostingController?.rootView = RMCharacterView(character: character)
        }
    }
}
