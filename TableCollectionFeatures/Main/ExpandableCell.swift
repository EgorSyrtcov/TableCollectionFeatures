//
//  ExpandableCell.swift
//  TableCollectionFeatures
//
//  Created by Egor Syrtcov on 16.06.22.
//

import UIKit
import SnapKit

final class ExpandableCell: UICollectionViewCell {
    
    //MARK: Переопределяем isSelected
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    private lazy var arrowImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "down-arrow")?.withRenderingMode(.alwaysTemplate))
        im.tintColor = .black
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(mainContainer)
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        topContainer.addSubview(arrowImageView)
        mainContainer.backgroundColor = .yellow
        topContainer.backgroundColor = .green
    }
    
    private func setupConstraints() {
        
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }

    private func updateAppearance() {
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
}
