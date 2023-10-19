//
//  MoviesViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 09.10.23.
//

import UIKit
import SnapKit

class MoviesViewController: UIViewController {
    //MARK: Properties
    private var movies = [Movie]()
    private var genres = [Genre]()
    private var userId: Int?
    private var name: String?
    var hasReachedLastCell = false
    private var genreId: Int?
    private var section: Section?
    private var page = 1
    private var maxPage: Int?
    private var isFromProfile = false
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
                return MoviesViewController.createCompositionalLayout()
            }))
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let searchForMoviesButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Search for movies", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: Initialization for genre id
    init(genreId: Int) {
        self.genreId = genreId
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: Initialization for section
    init(section: Section) {
        self.section = section
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: Initialization for movie name
    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: Initialization for user id
    init(userId: Int, isFromProfile: Bool) {
        self.userId = userId
        self.isFromProfile = isFromProfile
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
        view.addSubview(searchForMoviesButton)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                if ((self?.isFromProfile) != nil) {
                    self?.searchForMoviesButton.isHidden = self?.movies.count != 0
                }
                self?.collectionView.reloadData()
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "Can't get movies", actionTitle: "OK")
            }
            self?.spinner.stopAnimating()
        }
        
        setupUI()
        addLongPressGesture()
        addSwipeUpGesture()
        searchForMoviesButton.addTarget(self, action: #selector(searchForMoviesButtonTapped), for: .touchUpInside)
    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        collectionView.snp.makeConstraints { make in
            make.left.top.width.height.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        searchForMoviesButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: add long press gesture recognizer
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    //MARK: add swipe up gesture for refresinh data
    private func addSwipeUpGesture() {
        if isFromProfile {
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
            swipeUp.direction = .down
            swipeUp.delegate = self
            collectionView.addGestureRecognizer(swipeUp)
        }
    }
    
    //MARK: change navigation controller when search movies button tapped
    @objc func searchForMoviesButtonTapped() {
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: handle swipe up gesture
    @objc func handleSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.movies.removeAll()
            self.collectionView.reloadData()
            self.spinner.startAnimating()
            
            getMovies { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.searchForMoviesButton.isHidden = self?.movies.count != 0
                    self?.collectionView.reloadData()
                case .failure(_):
                    Haptics.shared.triggerNotificationFeedback(type: .error)
                    self?.showMessage(alertTitle: "Error", message: "Can't get movies", actionTitle: "OK")
                }
                self?.spinner.stopAnimating()
            }
        }
    }

}

//MARK: handle long press
extension MoviesViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began && UserDefaults.standard.value(forKey: "UserId") != nil
        {
            Haptics.shared.triggerImpactFeedback()
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                var alertTitle: String?
                var alertMessage: String?
                var actionTitle: String?
                var successMessage: String?
                var errorMessage: String?
                
                if isFromProfile {
                    alertTitle = "Remove from favourites"
                    alertMessage = "Are you sure remove \"\(movies[indexPath.row].title)\" from favourites ?"
                    actionTitle = "Remove"
                    successMessage = "Movie successfully removed from favourites"
                    errorMessage = "Can't remove movie from favourites"
                }
                else {
                    alertTitle = "Add to favourites"
                    alertMessage = "Are you sure add \"\(movies[indexPath.row].title)\" to favourites ?"
                    actionTitle = "Add"
                    successMessage = "Movie successfully added to favourites"
                    errorMessage = "Can't add movie to favourites"
                }
                
                let alert = UIAlertController(title: alertTitle,
                                              message: alertMessage,
                                              preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: actionTitle, style: .default) {[weak self] _ in
                    guard let movieId = self?.movies[indexPath.row].id,
                          let userId = UserDefaults.standard.value(forKey: "UserId") as? Int,
                          let self = self
                    else {
                        return
                    }
                    
                    ApiCaller.shared.addOrRemoveFromFavourite(with: movieId, userId: userId, add: !isFromProfile, sessionDelegate: self) { result in
                        if result {
                            Haptics.shared.triggerNotificationFeedback(type: .success)
                            self.showMessage(alertTitle: "Success", message: successMessage ?? "", actionTitle: "OK")
                            if self.isFromProfile {
                                self.movies.remove(at: indexPath.row)
                                self.collectionView.reloadData()
                                self.searchForMoviesButton.isHidden = self.movies.count != 0
                            }
                        }
                        else {
                            Haptics.shared.triggerNotificationFeedback(type: .error)
                            self.showMessage(alertTitle: "Error", message: errorMessage ?? "", actionTitle: "OK")
                        }
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    present(alert, animated: true)
                }
                else {
                    if let popoverController = alert.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    else {
                        present(alert, animated: true)
                    }
                }
            }
        }
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

//MARK: get movies from api
extension MoviesViewController {
    private func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        DispatchQueue.main.async {
            
            //MARK: get genres
            ApiCaller.shared.getGenres(sessionDelegate: self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.genres = data.genres
                case .failure(_): break
                }
            }
            
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
            
            //MARK: get movies by name
            if let name = self.name {
                ApiCaller.shared.getMoviesByName(with: name, page: self.page, sessionDelegate: self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.maxPage = data.total_pages
                        completion(.success(data.results))
                    case .failure(_):
                        completion(.failure(NSError()))
                    }
                }
            }
            
            //MARK: get movies by user id
            if let userId = self.userId {
                ApiCaller.shared.getMoviesByUserId(with: userId, page: self.page, sessionDelegate: self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.maxPage = data.total_pages
                        completion(.success(data.results))
                    case .failure(_):
                        completion(.failure(NSError()))
                    }
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.identifier,
            for: indexPath) as? MovieCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let movieGenres = genres.filter { genre in
            movie.genre_ids.contains(genre.id)
        }
        
        let movieVC = MovieViewController(movie: movie, genres: movieGenres)
        navigationController?.pushViewController(movieVC, animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

//MARK: handle how much scrolled for pagination
extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalPercentage = scrollView.contentOffset.y / max(1, scrollView.contentSize.height - scrollView.bounds.size.height)
        if(verticalPercentage > 0.6 && !hasReachedLastCell) {
            hasReachedLastCell = true
            self.page += 1
            guard let maxPage = self.maxPage, self.page <= maxPage else { return }
            
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
