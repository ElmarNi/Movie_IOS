//
//  GenreCollectionViewCell.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let genreName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 237.0 / 255.0, green:  17.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.00)
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        addSubview(genreName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genreName.sizeToFit()
        genreName.frame = CGRect(x: 5, y: 5, width: width - 10, height: height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String) {
        genreName.text = text
    }
}
