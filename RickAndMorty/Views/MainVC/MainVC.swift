//
//  MainVC.swift
//  RickAndMorty
//
//  Created by Mostafa Sayed on 30/11/2024.
//

import UIKit
import Combine

final class MainVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var mainHeaderView: MainHeaderView!

    private var diffableDataSource: UITableViewDiffableDataSource<Int, RMCharacterVM>?
    private var charactersVM: RMCharactersVM?
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoadingMore = false // Debounce scroll events
    private let refreshControl = UIRefreshControl()
    private var filteringStatus: CharacterStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersVM = RMCharactersVM()
        setupTableView()
        setupTableHeader()
        bindViewModel()
        setupDiffableDataSource()
        loadData()
    }
    
    private func setupTableView() {
        tableView.register(RMCharacterTableCell.self, forCellReuseIdentifier: RMCharacterTableCell.reuseIdentifier)
        tableView.delegate = self // For pagination
        
        tableView.refreshControl = refreshControl // Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupTableHeader() {
        mainHeaderView.statusSelected = { [weak self] selectedStatus in
            self?.handleStatusSelection(status: selectedStatus)
        }
    }

    private func handleStatusSelection(status: CharacterStatus?) {
        self.filteringStatus = status
        loadData()
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UITableViewDiffableDataSource<Int, RMCharacterVM>(tableView: tableView) { tableView, indexPath, character in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RMCharacterTableCell.reuseIdentifier, for: indexPath) as? RMCharacterTableCell else {
                return UITableViewCell()
            }
            cell.configure(with: character)
            return cell
        }
    }
    
    private func loadData(reset: Bool = false) {
        Task {
            await charactersVM?.fetchCharacters(status: filteringStatus?.rawValue, reset: reset)
        }
    }
    
    @objc private func refreshData() {
        loadData(reset: true) // Reset pagination
    }
    
    private func bindViewModel() {
        charactersVM?.$characters
            .receiveOnMain()
            .sink { [weak self] receivedValue in
                self?.isLoadingMore = false
                self?.setTableData(characters: receivedValue)
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        charactersVM?.$error
            .receiveOnMain()
            .sink { [weak self] error in
                self?.refreshControl.endRefreshing()
                if let error {
                    self?.showError(error: error)
                }
            }
            .store(in: &cancellables)
        
        charactersVM?.$isLoading
            .receiveOnMain()
            .sink { [weak self] isLoading in
                if isLoading && !(self?.refreshControl.isRefreshing ?? false) {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
        
    }

    @MainActor
    private func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.loadData()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }

    @MainActor
    private func setTableData(characters: [RMCharacterVM]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RMCharacterVM>()
        snapshot.appendSections([0])
        snapshot.appendItems(characters)
        self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showLoadingIndicator() {
        let footerView = UIActivityIndicatorView(style: .medium)
        footerView.startAnimating()
        tableView.tableFooterView = footerView
    }
    
    private func hideLoadingIndicator() {
        tableView.tableFooterView = nil
    }

    private func showCharacterDetails(characterDetails: RMCharacterVM) {
        let detailsVC = CharacterDetailsVC()
        detailsVC.characterDetails = characterDetails
        detailsVC.modalPresentationStyle = .overFullScreen
        detailsVC.modalTransitionStyle = .crossDissolve
        present(detailsVC, animated: true)
    }
}

// MARK: - UITableViewDelegate for Pagination
extension MainVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Detect if the user is near the bottom of the table view
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        guard !isLoadingMore else { return } // Prevent multiple calls

        if offsetY > (contentHeight - frameHeight - 100) {
            isLoadingMore = true
            loadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCharacter = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        showCharacterDetails(characterDetails: selectedCharacter)
    }
}
