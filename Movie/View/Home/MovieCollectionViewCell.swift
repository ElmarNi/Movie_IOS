//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 09.10.23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImage)
        contentView.addSubview(spinner)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        spinner.center = contentView.center
        coverImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(movie: Movie) {
        if let url = URL(string: "http://image.tmdb.org/t/p/w300/\(movie.poster_path)") {
            coverImage.downloaded(from: url, completion: {[weak self] in
                self?.spinner.stopAnimating()
            })
        }
    }
}
