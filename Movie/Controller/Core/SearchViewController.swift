//
//  SearchViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    //MARK: Properties
    private var genres = [Genre]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
        sc.automaticallyShowsCancelButton = false
        return sc
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
                return SearchViewController.createCompositionalLayout()
            }))
        
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        getGenres()
        setupUI()
        addTapGesture()
    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        collectionView.snp.makeConstraints { make in
            make.left.top.width.height.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: tap gesture when tapped outside of search bar
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        searchController.searchBar.endEditing(false)
    }
    
}

//MARK: search controller and search bar delegates
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let moviesVC = MoviesViewController(name: searchText)
        navigationController?.pushViewController(moviesVC, animated: true)
    }
}

//MARK: collection view data source and delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.identifier,
            for: indexPath) as? GenreCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(text: genres[indexPath.row].name)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
        let moviesVC = MoviesViewController(genreId: genre.id)
        moviesVC.title = genre.name
        navigationController?.pushViewController(moviesVC, animated: true)
    }
}

//MARK: createing compositional layout
extension SearchViewController {
    private static func createCompositionalLayout() -> NSCollectionLayoutSection{
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(50)),
                                                       subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

//MARK: get genres data
extension SearchViewController {
    private func getGenres() {
        ApiCaller.shared.getGenres(sessionDelegate: self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.genres = data.genres
                self?.collectionView.reloadData()
                self?.spinner.stopAnimating()
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "No results", actionTitle: "OK")
                self?.spinner.stopAnimating()
            }
        }
    }
}
