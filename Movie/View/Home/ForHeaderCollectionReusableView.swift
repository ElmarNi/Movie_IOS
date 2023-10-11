//
//  ForHeaderCollectionReusableView.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 05.10.23.
//

import UIKit

protocol ForHeaderCollectionReusableViewDelegate: AnyObject {
    func seeAllButtonTapped(section: Section)
}

class ForHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ForHeaderCollectionReusableView"
    weak var delegate: ForHeaderCollectionReusableViewDelegate?
    var section: Section?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let seeAllBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("See all", for: .normal)
        btn.setTitleColor(UIColor(red: 1.00, green: 0.22, blue: 0.37, alpha: 1.00), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(seeAllBtn)
        seeAllBtn.addTarget(self, action: #selector(seeAllBtnTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        seeAllBtn.sizeToFit()
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleLabel.width, height: height)
        seeAllBtn.frame = CGRect(x: width - seeAllBtn.width, y: 0, width: seeAllBtn.width, height: height)
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc func seeAllBtnTapped() {
        
        if let section = self.section {
            delegate?.seeAllButtonTapped(section: section)
//            print("S")
        }
    }
}
