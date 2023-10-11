//
//  MoviesViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 09.10.23.
//

import UIKit

class MoviesViewController: UIViewController {
    private var movies = [Movie]()
    var hasReachedLastCell = false
    private var genreId: Int?
    private var section: Section?
    private var page = 1
    private var maxPage: Int?
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(genreId: Int) {
        self.genreId = genreId
        super.init(nibName: nil, bundle: nil)
    }
    
    init(section: Section) {
        self.section = section
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
        
        getMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                
                self?.collectionView.reloadData()
            case .failure(_):
                self?.showError(alertTitle: "Error", message: "Can't get movies", actionTitle: "OK")
            }
            self?.spinner.stopAnimating()
        }
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
    private func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        DispatchQueue.main.async {
            //MARK: get movies by genreId
            if let genreId = self.genreId {
                ApiCaller.shared.getMoviesByGenreId(with: genreId, page: self.page, sessionDelegate: self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.maxPage = data.total_pages
                        completion(.success(data.results))
                    case .failure(_):
                        completion(.failure(NSError()))
                    }
                }
            }
            //MARK: get movies by section
            if let section = self.section {
                switch section {
                case .UpcomingMovies(_):
                    ApiCaller.shared.getUpcomingMovies(page: self.page, sessionDelegate: self) { [weak self] result in
                        switch result {
                        case .success(let data):
                            self?.maxPage = data.total_pages
                            completion(.success(data.results))
                        case .failure(_):
                            completion(.failure(NSError()))
                        }
                    }
                case .PopularMovies(_):
                    ApiCaller.shared.getPopularMovies(page: self.page, sessionDelegate: self) { [weak self] result in
                        switch result {
                        case .success(let data):
                            self?.maxPage = data.total_pages
                            completion(.success(data.results))
                        case .failure(_):
                            completion(.failure(NSError()))
                        }
                    }
                case .TopRatedMovies(_):
                    ApiCaller.shared.getTopRatedMovies(page: self.page, sessionDelegate: self) { [weak self] result in
                        switch result {
                        case .success(let data):
                            self?.maxPage = data.total_pages
                            completion(.success(data.results))
                        case .failure(_):
                            completion(.failure(NSError()))
                        }
                    }
                default:
                    break
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

//MARK: handle how much scrolled
extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalPercentage = scrollView.contentOffset.y / max(1, scrollView.contentSize.height - scrollView.bounds.size.height)
        if(verticalPercentage > 0.6 && !hasReachedLastCell) {
            hasReachedLastCell = true
            self.page += 1
            if let maxPage = self.maxPage, self.page <= maxPage {
                getMovies { [weak self] result in
                    switch result {
                    case .success(let movies):
                        self?.movies += movies
                        self?.collectionView.reloadData()
                        self?.hasReachedLastCell = false
                    case .failure(_):
                        self?.hasReachedLastCell = false
                    }
                }
            }
        }
    }
}
