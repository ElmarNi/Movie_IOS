//
//  RecommendedMovieCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class TopRatedMovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopRatedMovieCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let startImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 200/255, green: 8/255, blue: 81/255, alpha: 1.0)
        return imageView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 200/255, green: 8/255, blue: 81/255, alpha: 1.0)
        return label
    }()
    
    private let rateStackView = UIStackView()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(spinner)
        contentView.addSubview(title)
        contentView.addSubview(rateStackView)
        rateStackView.addSubview(startImageView)
        rateStackView.addSubview(rateLabel)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 200/255, green: 8/255, blue: 81/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 233/255, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(movie: Movie) {
        if  let urlString = movie.backdrop_path,
            let url = URL(string: "http://image.tmdb.org/t/p/w200/\(urlString)") {
            coverImageView.download(from: url, sessionDelegate: self, completion: {[weak self] in
                self?.spinner.stopAnimating()
            })
        }
        coverImageView.backgroundColor = .red
        title.text = movie.title
        rateLabel.text = "\(movie.vote_average)/10"
        
        
        coverImageView.frame = CGRect(x: 10, y: 10, width: 120, height: height - 20)
        spinner.frame = CGRect(x: coverImageView.width / 2, y: coverImageView.height / 2, width: 0, height: 0)
        let titleHeight = title.calculateLabelHeight(width: width - coverImageView.width - 5)
        title.frame = CGRect(x: coverImageView.right + 5, y: 10, width: width - coverImageView.width - 5, height: min(50, titleHeight))
        rateStackView.frame = CGRect(x: coverImageView.right + 5, y: height - 30, width: 75, height: 20)
        startImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        rateLabel.frame = CGRect(x: startImageView.right, y: 1, width: 50, height: 20)
    }
}
