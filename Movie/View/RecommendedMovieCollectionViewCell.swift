//
//  RecommendedMovieCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class RecommendedMovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedMovieCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
