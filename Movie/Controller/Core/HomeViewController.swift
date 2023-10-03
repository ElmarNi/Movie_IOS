//
//  HomeViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

enum Section {
    case Genre
    case PopularMovie
    case NewReleaseMovie
    case RecommendedMovie
    var title: String {
        switch self {
            case .Genre: return "Genres"
            case .PopularMovie: return "Popular movies"
            case .NewReleaseMovie: return "New Releases"
            case .RecommendedMovie: return "Recommended Movies"
        }
    }
}

class HomeViewController: UIViewController {
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append(Section.Genre)
        sections.append(Section.PopularMovie)
        sections.append(Section.NewReleaseMovie)
        sections.append(Section.RecommendedMovie)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.register(PopularMovieCollectionViewCell.self, forCellWithReuseIdentifier: PopularMovieCollectionViewCell.identifier)
        collectionView.register(NewReleaseMovieCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseMovieCollectionViewCell.identifier)
        collectionView.register(RecommendedMovieCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedMovieCollectionViewCell.identifier)
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [self] (sectionNumber, env) -> NSCollectionLayoutSection? in

            switch self.sections[sectionNumber] {
            case .Genre:
                return self.genreLayoutSection()
            case .PopularMovie:
                return self.popularMoviesLayoutSection()
            case .NewReleaseMovie:
                return self.newReleseasesMovieLayoutSection()
            case .RecommendedMovie:
                return self.recommendedMoviesLayoutSection()
            }
            
        }
    }
    
    private func genreLayoutSection() -> NSCollectionLayoutSection {
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
        return section
    }
    
    private func popularMoviesLayoutSection() -> NSCollectionLayoutSection {
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                                                          heightDimension: .absolute(300)),
                                                       subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func newReleseasesMovieLayoutSection() -> NSCollectionLayoutSection {
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
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func recommendedMoviesLayoutSection() -> NSCollectionLayoutSection {
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
        section.orthogonalScrollingBehavior = .none
        return section
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .Genre:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, 
                                                             for: indexPath) as? GenreCollectionViewCell {
                cell.configure(text: "GENRE")
                return cell
            }
        case .PopularMovie:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCollectionViewCell.identifier, 
                                                             for: indexPath) as? PopularMovieCollectionViewCell {
                
                return cell
            }
        case .NewReleaseMovie:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseMovieCollectionViewCell.identifier,
                                                             for: indexPath) as? NewReleaseMovieCollectionViewCell {
                
                return cell
            }
        case .RecommendedMovie:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedMovieCollectionViewCell.identifier,
                                                             for: indexPath) as? RecommendedMovieCollectionViewCell {
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
}
