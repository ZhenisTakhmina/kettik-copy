//
//  KTTripDetailsScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI

final class KTTripDetailsScreen: KTScrollableViewController {
    
    override var prefersNavigationBarHidden: Bool {
        true
    }
    
    private let viewModel: KTTripDetailsViewModel
    
    private let navigationView: NavigationView = .init()
    
    private var images: [URL]? = []
        
    private let thumbnailView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let nameLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 20)
        $0.textColor = KTColors.Text.primary.color
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
    }
    
    private let difficultyView: KTDifficultyView = .init().then {
        $0.font = KTFonts.SFProText.medium.font(size: 16)
        $0.layer.cornerRadius = 8
    }
    
    private let locationView: KTIconTextView = .init().then {
        $0.set(icon: KTImages.Icon.location.image)
    }
    
    private let dateView: KTIconTextView = .init().then {
        $0.set(icon: KTImages.Icon.calendar.image)
    }
    
    private let durationView: KTIconTextView = .init().then {
        $0.set(icon: KTImages.Icon.clock.image)
    }
    
    private let guideLabel: UILabel = .init().then {
        $0.text = "Guide: Zhenis Takhmina"
        $0.font = KTFonts.SFProText.bold.font(size: 16)
        $0.numberOfLines = 0
        $0.textColor = KTColors.Text.primary.color
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
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(ImagesCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let footerView: KTTripDetailsFooterView = .init()
    
    init(viewModel: KTTripDetailsViewModel) {
        self.viewModel = viewModel
        super.init()
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentInset.bottom = footerView.bounds.height + 24
    }
    
    override func setupViews() {
        super.setupViews()
        scrollView.contentInset.top = UIScreen.main.bounds.width
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        contentView.backgroundColor = KTColors.Surface.primary.color
        
        setupContent()
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTTripDetailsViewModel.Input = .init(
            back: navigationView.backButton.rx.tap.mapToVoid(), 
            toggleFavourite: navigationView.toggleLikeButton.rx.tap.mapToVoid(),
            order: footerView.bookButton.rx.tap.mapToVoid()
        )
        let output: KTTripDetailsViewModel.Output = viewModel.transform(input: input)
        
        output.displayTrip
            .drive(onNext: { [unowned self] trip in
                images = trip.imagesURL
                thumbnailView.setImage(with: trip.thumbnailURL)
                nameLabel.text = trip.name?[KTTripAdapter.shared]
                descriptionLabel.text = trip.description?[KTTripAdapter.shared]
                locationView.set(text: trip.location?[KTTripAdapter.shared])
                dateView.set(text: trip.date)
                durationView.set(text: trip.duration?[KTTripAdapter.shared])
                if let difficulty = trip.difficulty {
                    difficultyView.set(difficulty: difficulty)
                    difficultyView.isHidden = false
                } else {
                    difficultyView.isHidden = true
                }
                footerView.set(trip: trip)
            })
            .disposed(by: disposeBag)
        
        output.isFavourite
            .drive(onNext: { [weak self] isFavourite in
                self?.navigationView.set(isFavourite: isFavourite)
            })
            .disposed(by: disposeBag)
    }
}

private extension KTTripDetailsScreen {
    
    func setupContent() {
        
        let headerView: UIImageView = .init(image: KTImages.Element.tripDetailsHeader.image).then {
            $0.contentMode = .scaleToFill
        }
        
        let descriptionTitleLabel: UILabel = .init().then {
            $0.text = KTStrings.Trip.aboutTour
            $0.font = KTFonts.SFProText.bold.font(size: 18)
        }
        
        let detailsView: UIStackView = .init(arrangedSubviews: [
            difficultyView,
            dateView,
            durationView,
            UIView()
        ]).then {
            $0.alignment = .center
            $0.spacing = 15
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            nameLabel,
            detailsView,
            locationView,
            descriptionTitleLabel,
            descriptionLabel,
            guideLabel,
            collectionView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.setCustomSpacing(12, after: nameLabel)
            $0.setCustomSpacing(24, after: locationView)
            $0.setCustomSpacing(14, after: dateView)
            $0.setCustomSpacing(12, after: descriptionTitleLabel)
            $0.setCustomSpacing(12, after: detailsView)
        }
        
        view.add(thumbnailView, {
            $0.height.equalTo(thumbnailView.snp.width)
            $0.top.trailing.leading.equalToSuperview()
        })
        view.bringSubviewToFront(scrollView)
        view.add(navigationView, {
            $0.top.trailing.leading.equalToSuperview()
        })
        view.add(footerView) {
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.top)
        }
        
        contentView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 20, vertical: 12))
        })
        difficultyView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 84, height: 32))
        }
        collectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
    }
}

extension KTTripDetailsScreen: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let image = images?[indexPath.item]
        cell.set(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images?[indexPath.item]
        let fullScreenImageView = KTFullScreenImageViewController()
        fullScreenImageView.setImage(selectedImage)
        fullScreenImageView.modalPresentationStyle = .overFullScreen
        present(fullScreenImageView, animated: true)
    }
}

extension KTTripDetailsScreen: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -scrollView.bounds.width {
            scrollView.setContentOffset(.init(x: 0, y: -scrollView.bounds.width), animated: false)
        }
    }
}

fileprivate final class NavigationView: KTView {
    
    let backButton: KTImageButton = .init(image: KTImages.Control.backNavBar.image)
    let toggleLikeButton: KTImageButton = .init(image: KTImages.Control.likeNavBar.image)
    
    override func setupViews() {
        super.setupViews()
        add(
            UIStackView(arrangedSubviews: [
                backButton,
                UIView(),
                toggleLikeButton
            ]).then {
                $0.alignment = .center
                $0.addShadow()
            }
        , {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            $0.trailing.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview()
        })
    }
    
    func set(isFavourite: Bool) {
        toggleLikeButton.setImage(
            isFavourite
                ? KTImages.Control.likedNavBar.image
                : KTImages.Control.likeNavBar.image,
            for: .normal
        )
    }
}

fileprivate final class ImagesCell: KTCollectionViewCell {
    
    private let imagesView: KTImagesCellView = .init()
    
    override func setupViews() {
        super.setupViews()
        contentView.add(imagesView, {
            $0.edges.equalToSuperview()

        })
    }
    
    func set(image: URL?) {
        imagesView.set(image: image)
    }
}


