//
//  FilterStatusCollectionCell.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import UIKit

final class FilterStatusCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterStatusCollectionCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with status: CharacterStatus, isSelected: Bool) {
        label.text = status.rawValue
        contentView.backgroundColor = isSelected ? UIColor.systemBlue : UIColor.clear
        label.textColor = isSelected ? UIColor.white : UIColor.black
    }
}
