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
    
    // MARK: Констрейнт для сжатого состояния
    private var collapsedConstraint: Constraint!

    // MARK: Констрейнт для расширенного состояния
    private var expandedConstraint: Constraint!
    
    private let mainContainer = UIView()
    private let topContainer = UIView()
    private let bottomContainer = UIView()
    
    private let arrowImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "down-arrow")?.withRenderingMode(.alwaysTemplate))
        im.tintColor = .black
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    private let titleLabel: UILabel = {
       let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(title: String) {
        titleLabel.text = title
    }
    
    private func configureView() {
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        
        contentView.addSubview(mainContainer)
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        mainContainer.addSubview(titleLabel)
        bottomContainer.addSubview(titleLabel)
        
        topContainer.addSubview(arrowImageView)
        contentView.backgroundColor = .yellow
        bottomContainer.backgroundColor = .red
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
        
        // MARK: Констрейнт для сжатого состояния (низ ячейки совпадает с низом верхнего контейнера)
        topContainer.snp.prepareConstraints { make in
            collapsedConstraint = make.bottom.equalToSuperview().constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
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
            make.height.lessThanOrEqualTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.bottom.equalToSuperview().offset(-16)
        }
        
        // MARK: Констрейнт для расширенного состояния (низ ячейки совпадает с низом нижнего контейнера)
        bottomContainer.snp.prepareConstraints { make in
            expandedConstraint = make.bottom.equalToSuperview().constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }

    private func updateAppearance() {

        collapsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
}
