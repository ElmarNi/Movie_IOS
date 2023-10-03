//
//  NewReleasesCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class NewReleaseMovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
