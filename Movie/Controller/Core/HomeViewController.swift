//
//  HomeViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit
import SnapKit

enum Section {
    case Genre(data: [Genre])
    case UpcomingMovies(data: [Movie])
    case PopularMovies(data: [Movie])
    case TopRatedMovies(data: [Movie])
    var title: String {
        switch self {
        case .Genre: return "Genres"
        case .UpcomingMovies: return "Upcoming movies"
        case .PopularMovies: return "Popular movies"
        case .TopRatedMovies: return "Top rated Movies"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var sections = [Section]()
    private var genres = [Genre]()
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
                return HomeViewController.createCompositionalLayout(section: sectionIndex)
            }))
        
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(TopRatedMovieCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedMovieCollectionViewCell.identifier)
        collectionView.register(ForHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ForHeaderCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSectionsData()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(spinner)
        setupUI()
        addLongPressGesture()
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
    
    //MARK: add long press
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
}

//MARK: creating compositional layout
extension HomeViewController {
    private static func createCompositionalLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            //MARK: for genres
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                                              heightDimension: .absolute(40)),
                                                           subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            return section
        case 1:
            //MARK: for upcoming movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                                                                              heightDimension: .absolute(320)),
                                                           subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(30)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            return section
        case 2:
            //MARK: for popular movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                                                              heightDimension: .absolute(210)),
                                                           subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            
            //header
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(30)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            return section
        default:
            //MARK: for top rated movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                              heightDimension: .absolute(120)),
                                                           subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            
            //header
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(30)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .none
            return section
        }
    }
}

//MARK: get datas from apis
extension HomeViewController {
    private func configureSectionsData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        var genres = [Genre]()
        var popularMovies = [Movie]()
        var upcomingMovies = [Movie]()
        var topRatedMovies = [Movie]()
        
        ApiCaller.shared.getGenres(sessionDelegate: self) { [weak self] result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                genres = data.genres
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "Can't get genres", actionTitle: "OK")
            }
        }
        
        ApiCaller.shared.getUpcomingMovies(page: 1, sessionDelegate: self) { [weak self] result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                upcomingMovies = data.results
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "Can't get upcoming movies", actionTitle: "OK")
            }
        }
        
        ApiCaller.shared.getPopularMovies(page: 1, sessionDelegate: self) { [weak self] result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                popularMovies = data.results
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "Can't get popular movies", actionTitle: "OK")
            }
        }
        
        ApiCaller.shared.getTopRatedMovies(page: 1, sessionDelegate: self) { [weak self] result in
            defer {
                dispatchGroup.leave()
            }
            switch result {
            case .success(let data):
                topRatedMovies = data.results
            case .failure(_):
                Haptics.shared.triggerNotificationFeedback(type: .error)
                self?.showMessage(alertTitle: "Error", message: "Can't get top rated movies", actionTitle: "OK")
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.sections.append(Section.Genre(data: genres))
            self?.sections.append(Section.UpcomingMovies(data: upcomingMovies))
            self?.sections.append(Section.PopularMovies(data: popularMovies))
            self?.sections.append(Section.TopRatedMovies(data: topRatedMovies))
            self?.genres = genres
            self?.collectionView.reloadData()
            self?.spinner.stopAnimating()
        }
        
    }
    
}

//MARK: collection view data source and delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .Genre(let model):
            return model.count
        case .UpcomingMovies(let model):
            return model.count
        case .PopularMovies(let model):
            return model.count
        case .TopRatedMovies(let model):
            return model.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .Genre(let genres):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreCollectionViewCell.identifier,
                for: indexPath) as? GenreCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(text: genres[indexPath.row].name)
            return cell
        case .UpcomingMovies(let movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(movie: movies[indexPath.row])
            return cell
        case .PopularMovies(let movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(movie: movies[indexPath.row])
            return cell
        case .TopRatedMovies(let movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopRatedMovieCollectionViewCell.identifier,
                for: indexPath) as? TopRatedMovieCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(movie: movies[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ForHeaderCollectionReusableView.identifier,
                for: indexPath) as? ForHeaderCollectionReusableView
            else {
                return UICollectionReusableView()
            }
            headerView.configure(title: sections[indexPath.section].title)
            headerView.section = sections[indexPath.section]
            headerView.delegate = self
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .Genre(let genres):
            let genre = genres[indexPath.row]
            let moviesVC = MoviesViewController(genreId: genre.id)
            moviesVC.title = genre.name
            navigationController?.pushViewController(moviesVC, animated: true)
        case .UpcomingMovies(let movies):
            let movie = movies[indexPath.row]
            let movieGenres = genres.filter { genre in
                movie.genre_ids.contains(genre.id)
            }
            
            let movieVC = MovieViewController(movie: movie, genres: movieGenres)
            navigationController?.pushViewController(movieVC, animated: true)
        case .PopularMovies(let movies):
            let movie = movies[indexPath.row]
            let movieGenres = genres.filter { genre in
                movie.genre_ids.contains(genre.id)
            }
            
            let movieVC = MovieViewController(movie: movie, genres: movieGenres)
            navigationController?.pushViewController(movieVC, animated: true)
        case .TopRatedMovies(let movies):
            let movie = movies[indexPath.row]
            let movieGenres = genres.filter { genre in
                movie.genre_ids.contains(genre.id)
            }
            
            let movieVC = MovieViewController(movie: movie, genres: movieGenres)
            navigationController?.pushViewController(movieVC, animated: true)
        }
    }
}

//MARK: handle see all button click in headers by section
extension HomeViewController: ForHeaderCollectionReusableViewDelegate {
    func seeAllButtonTapped(section: Section) {
        let moviesVC = MoviesViewController(section: section)
        moviesVC.title = section.title
        navigationController?.pushViewController(moviesVC, animated: true)
        Haptics.shared.triggerSelectionFeedback()
    }
}

//MARK: handle long press gesture, long press gesture delegate
extension HomeViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began && UserDefaults.standard.value(forKey: "UserId") != nil
        {
            Haptics.shared.triggerImpactFeedback()
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                var movie: Movie?
                switch sections[indexPath.section] {
                case .UpcomingMovies(let movies):
                    movie = movies[indexPath.row]
                case .PopularMovies(let movies):
                    movie = movies[indexPath.row]
                case .TopRatedMovies(let movies):
                    movie = movies[indexPath.row]
                default: break
                }
                
                guard let movie = movie else { return }
                let alert = UIAlertController(title: "Add to favourite",
                                              message: "Are you sure add \"\(movie.title)\" to favourites ?",
                                              preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Add", style: .default) {[weak self] _ in
                    guard let userId = UserDefaults.standard.value(forKey: "UserId") as? Int,
                          let self = self
                    else {
                        return
                    }

                    ApiCaller.shared.addOrRemoveFromFavourite(with: movie.id, userId: userId, add: true, sessionDelegate: self) { result in
                        if result {
                            Haptics.shared.triggerNotificationFeedback(type: .success)
                            self.showMessage(alertTitle: "Success", message: "Movie successfully added to favourites", actionTitle: "OK")
                        }
                        else {
                            Haptics.shared.triggerNotificationFeedback(type: .error)
                            self.showMessage(alertTitle: "Error", message: "Can't add movie to favourites", actionTitle: "OK")
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
