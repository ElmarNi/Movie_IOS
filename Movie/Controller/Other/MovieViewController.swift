//
//  MovieViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 11.10.23.
//

import UIKit

class MovieViewController: UIViewController {

    private let movie: Movie
    private var genres: [Genre]
    
    private let scrollView = UIScrollView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let coverImageSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let genresStackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        return sv
    }()
    
    init(movie: Movie, genres: [Genre]) {
        self.movie = movie
        self.genres = genres
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = movie.title
        view.addSubview(scrollView)
        coverImageView.addSubview(coverImageSpinner)
        scrollView.addSubview(coverImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(genresStackView)
        scrollView.addSubview(overviewLabel)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        coverImageView.frame = CGRect(x: 10, y: 20, width: view.width - 20, height: 250)
        coverImageSpinner.frame = CGRect(x: coverImageView.width / 2, y: coverImageView.height / 2, width: 0, height: 0)
        
        titleLabel.frame = CGRect(x: 5,
                                  y: coverImageView.bottom + 10,
                                  width: view.width - 10,
                                  height: titleLabel.calculateLabelHeight(width: view.width - 10))
        
        scrollView.frame = view.bounds
        
        genresStackView.frame = CGRect(x: 0, y: titleLabel.bottom + 10, width: view.width, height: 35)
        
        overviewLabel.frame = CGRect(x: 5,
                                     y: genresStackView.bottom + 10,
                                     width: view.width - 10,
                                     height: overviewLabel.calculateLabelHeight(width: view.width - 10))
    }
    
    private func configure() {
        if let url = URL(string: "http://image.tmdb.org/t/p/w400/\(movie.backdrop_path ?? "")") {
            coverImageView.download(from: url, sessionDelegate: self, completion: {[weak self] in
                self?.coverImageSpinner.stopAnimating()
            })
        }
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        genres.enumerated().forEach { (index, genre) in
            if index < 3 {
                
                let genreButton = UIButton()
                genreButton.backgroundColor = UIColor(red: 237.0 / 255.0, green:  17.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.00)
                genreButton.layer.cornerRadius = 6
                genreButton.clipsToBounds = true
                genreButton.layer.masksToBounds = true
                genreButton.setTitle(genre.name, for: .normal)
                genreButton.titleLabel?.textColor = .white
                genreButton.titleLabel?.textAlignment = .center
                genreButton.titleLabel?.numberOfLines = 0
                genreButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
                genreButton.tag = genre.id
                genreButton.frame = CGRect(x: (view.width / 3 * CGFloat(index)) + 5,
                                          y: 0,
                                          width: view.width / 3 - 10,
                                          height: 35)
                genreButton.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
                genresStackView.addSubview(genreButton)
            }
        }
    }
    
    @objc func genreButtonTapped(_ sender: UIButton) {
        let moviesVC = MoviesViewController(genreId: sender.tag)
        moviesVC.title = sender.titleLabel?.text
        navigationController?.pushViewController(moviesVC, animated: true)
    }
}
