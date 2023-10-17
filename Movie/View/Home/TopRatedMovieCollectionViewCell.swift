//
//  RecommendedMovieCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit
import SnapKit

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
        contentView.addSubview(startImageView)
        contentView.addSubview(rateLabel)
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 200/255, green: 8/255, blue: 81/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 233/255, alpha: 1.0)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        coverImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().inset(10)
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        startImageView.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.left.equalTo(coverImageView.snp.right).offset(5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.left.equalTo(startImageView.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(coverImageView.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
            make.height.lessThanOrEqualToSuperview().offset(-45)
        }
    }
    
    public func configure(movie: Movie) {
        if  let urlString = movie.backdrop_path,
            let url = URL(string: "http://image.tmdb.org/t/p/w200/\(urlString)") {
            coverImageView.download(from: url, sessionDelegate: self, completion: {[weak self] in
                self?.spinner.stopAnimating()
            })
        }
        
        title.text = movie.title
        rateLabel.text = "\(movie.vote_average)/10"
    }
    
}
