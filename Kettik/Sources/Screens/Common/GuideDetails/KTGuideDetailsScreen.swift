//
//  KTGuideDetailsScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

// TODO: Рефакторинг. Перенести бизнес-логику во вьюмодель
final class KTGuideDetailsScreen: KTScrollableViewController {
    
    private let guide: KTGuideAdapter
    
    private var images: [URL]? = []
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    private let photoView: UIImageView = .init().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = KTColors.Surface.secondary.color
    }
    
    private let nameLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = KTColors.Text.primary.color
    }
    
    private let roleLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = KTColors.Text.secondary.color
    }
    
    private let descriptionLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 16)
        $0.numberOfLines = 0
        $0.textColor = KTColors.Text.primary.color
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        let view: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.register(GuidesCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init(guide: KTGuideAdapter) {
        self.guide = guide
        super.init()
        
        // TODO: move to viewmodel
        photoView.setImage(with: guide.photoURL)
        nameLabel.text = guide.name
        roleLabel.text = guide.role
        descriptionLabel.text = guide.description
        images = guide.imagesURL
    }
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Tab.guides
        let stackView: UIStackView = .init(arrangedSubviews: [
            photoView,
            nameLabel,
            roleLabel,
            descriptionLabel,
            collectionView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.setCustomSpacing(24, after: photoView)
            $0.setCustomSpacing(4, after: nameLabel)
            $0.setCustomSpacing(32, after: roleLabel)
            $0.setCustomSpacing(15, after: descriptionLabel)
        }
        
        contentView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 20, vertical: 12))
        })
        
        photoView.snp.makeConstraints {
            $0.size.equalTo(220)
        }
        collectionView.snp.makeConstraints {
            $0.width.equalTo(screenSize.width)
            $0.height.equalTo(200)
            
        }
    }
}

extension KTGuideDetailsScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GuidesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let image = images?[indexPath.item]
        cell.set(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images?[indexPath.item]
        let fullScreenImageView = KTFullScreenImageViewController()
        fullScreenImageView.setImage(selectedImage)
        fullScreenImageView.modalPresentationStyle = .overFullScreen
        present(fullScreenImageView, animated: true)
    }
}


fileprivate final class GuidesCell: KTCollectionViewCell {
    
    private let guidesView: KTImagesCellView = .init()
    
    override func setupViews() {
        super.setupViews()
        contentView.add(guidesView, {
            $0.edges.equalToSuperview()

        })
    }
    
    func set(image: URL?) {
        guidesView.set(image: image)
    }
}

