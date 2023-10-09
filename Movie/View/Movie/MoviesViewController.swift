//
//  MoviesViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 09.10.23.
//

import UIKit

class MoviesViewController: UIViewController {
    private var movies = [Movie]()
    
    private var genreId: Int
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
                return MoviesViewController.createCompositionalLayout()
            }))
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    init(genreId: Int) {
        self.genreId = genreId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(spinner)
        collectionView.delegate = self
        collectionView.dataSource = self
        getMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        spinner.center = view.center
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        movies = []
        spinner.startAnimating()
        collectionView.reloadData()
    }
    
}

//MARK: createing compositional layout
extension MoviesViewController {
    private static func createCompositionalLayout() -> NSCollectionLayoutSection{
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                                                                          heightDimension: .absolute(300)),
                                                       repeatingSubitem: item,
                                                       count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

//MARK: get datas from api
extension MoviesViewController {
    private func getMovies() {
        DispatchQueue.main.async {
            ApiCaller.shared.getMoviesByGenreId(with: self.genreId, page: 1, sessionDelegate: self) {[weak self] result in
                switch result {
                case .success(let data):
                    
                    self?.movies = data.results
                    self?.spinner.stopAnimating()
                    self?.collectionView.reloadData()
                case .failure(_):
                    self?.showError(alertTitle: "Error", message: "Can't get movies", actionTitle: "OK")
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
}

//MARK: collection view data source and delegate
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) 
            as? MovieCollectionViewCell
        {
            cell.configure(movie: movies[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
