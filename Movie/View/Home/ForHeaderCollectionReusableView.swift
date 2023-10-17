//
//  ForHeaderCollectionReusableView.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 05.10.23.
//

import UIKit
import SnapKit

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
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        titleLabel.snp.makeConstraints {[weak self] make in
            make.top.equalToSuperview()
            make.width.lessThanOrEqualTo(self?.width ?? 57 - 57)
            make.height.equalTo(20)
        }
        
        seeAllBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(20)
            make.trailing.equalToSuperview()
        }
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc func seeAllBtnTapped() {
        guard let section = self.section else { return }
        delegate?.seeAllButtonTapped(section: section)
    }
}
