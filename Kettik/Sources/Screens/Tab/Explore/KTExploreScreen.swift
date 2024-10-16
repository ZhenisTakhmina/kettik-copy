//
//  KTExploreScreen.swift
//  Kettik
//
//  Created by Tami on 25.02.2024.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI

final class KTExploreScreen: KTScrollableViewController {
    
    override var prefersNavigationBarHidden: Bool {
        true
    }
    
    private let viewModel: KTExploreViewModel
    
    private let navigationBarView: KTNavigationBarView = .init()
    private let refreshControl: UIRefreshControl = .init().then {
        $0.tintColor = KTColors.Brand.accent.color
    }
    private let tripsView: KTExploreTripsView = .init()
    
    init(viewModel: KTExploreViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupViews() {
        super.setupViews()
        setupNavigationBar()
        setupContentView()
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let loadData: Observable<Void> = .merge(
            rx.viewWillAppear.take(1).mapToVoid(),
            refreshControl.rx.controlEvent(.valueChanged).mapToVoid()
        )
        let input: KTExploreViewModel.Input = .init(
            loadData: loadData,
            selectTrip: tripsView.selectTrip,
            openSearch: navigationBarView.searchButton.rx.tap.mapToVoid(),
            showCollectionList: tripsView.showAll
        )
        let output: KTExploreViewModel.Output = viewModel.transform(input: input)
        
        output.collections
            .drive(onNext: { [weak self] collections in
                self?.tripsView.set(collections: collections)
            })
            .disposed(by: disposeBag)
    }
    
    override func set(loading: Bool) {
        super.set(loading: loading)
        if !loading {
            refreshControl.endRefreshing()
        }
    }
}

private extension KTExploreScreen {
    
    func setupNavigationBar() {
        view.add(navigationBarView) {
            $0.top.trailing.leading.equalToSuperview()
        }
    }
    
    func setupContentView() {
        scrollView.refreshControl = refreshControl
        
        scrollView.contentInset.top = 32
        scrollView.snp.removeConstraints()
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        contentView.add(tripsView) {
            $0.edges.equalToSuperview()
        }
    }
}

fileprivate final class KTNavigationBarView: KTView {
    
    let searchButton: KTImageButton = .init(image: KTImages.Icon.search.image)
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = KTColors.Surface.primary.color
        
        let titleLabel: UILabel = .init().then {
            $0.text = KTStrings.Explore.title
            $0.textColor = KTColors.Text.primary.color
            $0.font = KTFonts.SFProText.bold.font(size: 24)
        }
        
        add(searchButton) {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
        
        add(titleLabel) {
            $0.centerY.equalTo(searchButton.snp.centerY)
            $0.leading.equalToSuperview().offset(24)
        }
    }
}


