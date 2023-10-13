//
//  SearchViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class SearchViewController: UIViewController {
    private var genres = [Genre]()
    
    let spinner: UIActivityIndicatorView = {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        spinner.center = view.center
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
        if let searchText = searchBar.text {
            let moviesVC = MoviesViewController(name: searchText)
            navigationController?.pushViewController(moviesVC, animated: true)
        }
    }
}

//MARK: collection view data source and delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GenreCollectionViewCell.identifier,
            for: indexPath) as? GenreCollectionViewCell
        {
            cell.configure(text: genres[indexPath.row].name)
            return cell
        }
        return UICollectionViewCell()
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
    private func getData() {
        ApiCaller.shared.getGenres(sessionDelegate: self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.genres = data.genres
                self?.collectionView.reloadData()
                self?.spinner.stopAnimating()
            case .failure(_):
                self?.showError(alertTitle: "Error", message: "Can't get genres", actionTitle: "OK")
                self?.spinner.stopAnimating()
            }
        }
    }
}
