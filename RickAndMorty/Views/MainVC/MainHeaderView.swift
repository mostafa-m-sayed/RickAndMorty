//
//  MainHeaderView.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//
import UIKit

class MainHeaderView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, CharacterStatus>?
    private var selectedStatus: CharacterStatus?
    var statusSelected: ((CharacterStatus?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupDiffableDataSource()
        applySnapshot()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = 100
    }
    
    private func setupCollectionView() {
        collectionView.register(FilterStatusCollectionCell.self, forCellWithReuseIdentifier: FilterStatusCollectionCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Int, CharacterStatus>(collectionView: collectionView) { collectionView, indexPath, status in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterStatusCollectionCell.reuseIdentifier, for: indexPath) as? FilterStatusCollectionCell else {
                fatalError("Cannot dequeue StatusCollectionCell")
            }
            let isSelected = status == self.selectedStatus
            cell.configure(with: status, isSelected: isSelected)
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CharacterStatus>()
        snapshot.appendSections([0])
        snapshot.appendItems(CharacterStatus.allCases)
        diffableDataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.setSelection()
        }
    }
    
    private func setSelection() {
        for case let indexPath? in collectionView.indexPathsForVisibleItems {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? FilterStatusCollectionCell,
               let status = self.diffableDataSource?.itemIdentifier(for: indexPath) {
                let isSelected = status == self.selectedStatus
                cell.configure(with: status, isSelected: isSelected)
            }
        }
    }
}

extension MainHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let status = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        if selectedStatus == status {
            selectedStatus = nil
            statusSelected?(nil)
        } else {
            selectedStatus = status
            statusSelected?(status)
        }
        
        applySnapshot()
    }
}
