//
//  MovieViewController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 11.10.23.
//

import UIKit
import SnapKit
import youtube_ios_player_helper

class MovieViewController: UIViewController, YTPlayerViewDelegate {
    //MARK: Properties
    private let movie: Movie
    private var genres: [Genre]
    private let scrollView = UIScrollView()
    private var url: URL?
    
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
    
    private let genresStackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        return sv
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let playerView = YTPlayerView()
    
    //MARK: Initialization
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
        scrollView.isHidden = true
        view.addSubview(scrollView)
        scrollView.addSubview(playerView)
        playerView.delegate = self
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(genresStackView)
        scrollView.addSubview(overviewLabel)
        view.addSubview(spinner)
        configure()
        setupUI()
        getTrailer()
    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        scrollView.snp.makeConstraints { make in
            make.left.top.width.height.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        playerView.snp.makeConstraints { make in
            make.left.width.top.equalToSuperview()
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().inset(10)
            make.top.equalTo(playerView.snp.bottom).offset(5)
        }
        
        genresStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.width.equalToSuperview().inset(5)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().inset(10)
            make.top.equalTo(genresStackView.snp.bottom).offset(5)
        }
    }
    
    //MARK: get movie trailer
    private func getTrailer() {
        DispatchQueue.main.async {
            ApiCaller.shared.getMovieTrailer(with: self.movie.id, sessionDelegate: self) {[weak self] result in
                switch result {
                case .success(let key):
                    self?.spinner.stopAnimating()
                    self?.scrollView.isHidden = false
                    self?.playerView.load(withVideoId: key)
                case .failure(_):
                    self?.showMessage(alertTitle: "Error", message: "Can't get movie trailer", actionTitle: "OK")
                    self?.spinner.stopAnimating()
                    self?.scrollView.isHidden = false
                }
            }
        }
    }
    
    //MARK: Configure data for UI elements and create genres view
    private func configure() {
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
                                           height: 30)
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
