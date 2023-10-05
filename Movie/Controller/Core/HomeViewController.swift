//
//  HomeViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

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
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
                return HomeViewController.createCompositionalLayout(section: sectionIndex)
            }))
        
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.register(UpcomingMovieCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingMovieCollectionViewCell.identifier)
        collectionView.register(PopularMovieCollectionViewCell.self, forCellWithReuseIdentifier: PopularMovieCollectionViewCell.identifier)
        collectionView.register(TopRatedMovieCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedMovieCollectionViewCell.identifier)
        collectionView.register(ForHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ForHeaderCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSectionsData()
//        print(sections[0])
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
//        print(sections[0])
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
                                                                                              heightDimension: .absolute(50)),
                                                           subitems: [item])
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            return section
        case 1:
            //MARK: for popular movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                                                              heightDimension: .absolute(460)),
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
            //MARK: for new released movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                                                              heightDimension: .absolute(250)),
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
            //MARK: for recommended movies
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                              heightDimension: .absolute(80)),
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

//MARK: get datas from api's
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
                break
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
                break
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
                break
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
                break
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.sections.append(Section.Genre(data: genres))
            self?.sections.append(Section.UpcomingMovies(data: upcomingMovies))
            self?.sections.append(Section.PopularMovies(data: popularMovies))
            self?.sections.append(Section.TopRatedMovies(data: topRatedMovies))
            self?.collectionView.reloadData()
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
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreCollectionViewCell.identifier,
                for: indexPath) as? GenreCollectionViewCell
            {
                
                cell.configure(text: genres[indexPath.row].name)
                return cell
            }
        case .UpcomingMovies(let movies):
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UpcomingMovieCollectionViewCell.identifier,
                for: indexPath) as? UpcomingMovieCollectionViewCell
            {
                cell.configure(movie: movies[indexPath.row])
                return cell
            }
        case .PopularMovies(let movies):
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PopularMovieCollectionViewCell.identifier,
                for: indexPath) as? PopularMovieCollectionViewCell
            {
                
                return cell
            }
        case .TopRatedMovies(let movies):
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopRatedMovieCollectionViewCell.identifier,
                for: indexPath) as? TopRatedMovieCollectionViewCell
            {
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ForHeaderCollectionReusableView.identifier,
                for: indexPath) as? ForHeaderCollectionReusableView
            {
                headerView.configure(title: sections[indexPath.section].title)
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}
