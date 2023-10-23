//
//  ReviewCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 23.10.23.
//

import UIKit
import SnapKit

class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewCollectionViewCell"
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let vote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    private let authorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let review: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(authorName)
        contentView.addSubview(vote)
        contentView.addSubview(review)
        contentView.addSubview(authorImage)
        authorImage.addSubview(spinner)
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 200/255, green: 8/255, blue: 81/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor(red: 255/255, green: 226/255, blue: 233/255, alpha: 1.0)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: set up UI elements and constraints
    private func setupUI() {
        
        authorImage.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
        authorImage.layer.cornerRadius = authorImage.frame.size.width / 2
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
                
        authorName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(authorImage.snp.right).offset(5)
            make.right.equalToSuperview().inset(5)
            make.height.equalTo(20)
        }
        
        vote.snp.makeConstraints { make in
            make.top.equalTo(authorName.snp.bottom).offset(5)
            make.left.equalTo(authorImage.snp.right).offset(5)
            make.right.equalToSuperview().inset(5)
            make.height.equalTo(15)
        }
        review.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
            make.top.equalTo(authorImage.snp.bottom).offset(5)
        }
    }
    
    public func configure(with review: Review) {
        authorName.text = review.author
        vote.text = "Author rating: \(review.author_details.rating)/10"
        self.review.text = review.content
        guard let url = URL(string: "http://image.tmdb.org/t/p/w200/\(review.author_details.avatar_path ?? "")") else { return }
        authorImage.download(from: url, sessionDelegate: self, completion: {[weak self] in
            self?.spinner.stopAnimating()
        })
    }
}
