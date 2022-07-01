//
//  ViewController.swift
//  TableCollectionFeatures
//
//  Created by Egor Syrtcov on 16.06.22.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let cellId = "ExpandableCell"
    private let sizingCell = ExpandableCell()
    
    private var models = [Model]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true // для выбора сразу нескольких ячеек
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customData()
        configurateView()
        setupConstraints()
    }
    
    private func configurateView() {
        view.backgroundColor = .white
        navigationItem.title = "Main"
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(ExpandableCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func customData() {
        let model1 = Model(title: "Настройки", description: "ehj,wte ytkyulyuljhwt.jkrw t.jrt teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d teh'pie oi ")
        let model2 = Model(title: "Звук", description: "ehj,wte jhwt.jkrw t.jrt")
        let model3 = Model(title: "Видео", description: "ehj,wte jhwt.jkyuliu;iu;;oi'  iy ;iu; o;o;i rw t.jrt")
        let model4 = Model(title: "Системные настройки", description: "ehj,wte jhwt.jkrw t.jrt")
        let model5 = Model(title: "Профиль", description: "ehj,wte jhwt.j uo;uoy uo;io oiio.p.pp/d ")
        
        models.append(model1)
        models.append(model2)
        models.append(model3)
        models.append(model4)
        models.append(model5)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as?  ExpandableCell else { return UICollectionViewCell() }
        cell.setupCell(title: models[indexPath.item].description)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: Динамический расчет высоты
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        sizingCell.frame = CGRect(origin: .zero,
                                  size: CGSize(width: collectionView.bounds.width - 40, height: 1000))
        sizingCell.isSelected = isSelected
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size = sizingCell.systemLayoutSizeFitting(
            CGSize(width: collectionView.bounds.width - 40, height: .greatestFiniteMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
}

//MARK: Переопределяем метод для анимированного сворачивания ячейки
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        // MARK: Cкроллим так, чтобы при разворачивании ячейки, ее было полностью видно
        DispatchQueue.main.async {
            guard let attributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
                return
            }
            
            let desiredOffset = attributes.frame.origin.y - 20
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let maxPossibleOffset = contentHeight - collectionView.bounds.height
            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
            
            collectionView.setContentOffset(
                CGPoint(x: 0, y: finalOffset),
                animated: true
            )
            
            // MARK: Весь этот костыль можно спокойно заменить на:
            // collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            // Но тогда не будет инсета в 20 пикселей сверху (для красоты)
        }
        
        return true
    }
}

