//
//  MovieCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 09.10.23.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverImage)
        contentView.addSubview(spinner)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        setupUI()
    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        coverImage.snp.makeConstraints { make in
            make.left.top.width.height.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(movie: Movie) {
        guard let url = URL(string: "http://image.tmdb.org/t/p/w300/\(movie.poster_path)") else { return }
        coverImage.download(from: url, sessionDelegate: self, completion: {[weak self] in
            self?.spinner.stopAnimating()
        })
    }
}
