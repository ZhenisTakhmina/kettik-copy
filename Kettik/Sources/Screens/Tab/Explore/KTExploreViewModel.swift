//
//  KTExploreViewModel.swift
//  Kettik
//
//  Created by Tami on 25.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class KTExploreViewModel: KTViewModel {
    
    private let tripsCollectionsService: KTTripsCollectionsService
    private let tripsService: KTTripsService
    
    private let observableCollections: BehaviorRelay<[KTTripsCollection]> = .init(value: [])
    
    init(tripsCollectionsService: KTTripsCollectionsService, tripsService: KTTripsService) {
        self.tripsCollectionsService = tripsCollectionsService
        self.tripsService = tripsService
    }
}

private extension KTExploreViewModel {
    
    func reloadCollections() {
        defaultLoading.accept(true)
        tripsCollectionsService.rxGetCollections()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] collections in
                self?.handle(collections: collections)
            }, onFailure: { [weak self] error in
                self?.defaultLoading.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    func handle(collections: [KTTripsCollection]) {
        observableCollections.accept(collections)
        defaultLoading.accept(false)
    }
}

extension KTExploreViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let loadData: Observable<Void>
        let selectTrip: Observable<KTTripAdapter>
        let openSearch: Observable<Void>
        let showCollectionList: Observable<KTTripsCollection>
    }
    
    struct Output {
        
        let collections: Driver<[KTTripsCollection]>
    }
    
    func transform(input: Input) -> Output {
        input.loadData
            .bind(onNext: { [unowned self] in
                reloadCollections()
            })
            .disposed(by: disposeBag)
        
        input.selectTrip
            .map { KTTripDetailsScreen(viewModel: .init(trip: $0) )}
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        input.openSearch
            .map { KTSearchTripsScreen() }
            .map { PresentViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPresentViewController)
            .disposed(by: disposeBag)
        
        input.showCollectionList
            .map { KTTripsListScreen(viewModel: .init(collection: $0)) }
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        return .init(
            collections: observableCollections.asDriverOnErrorJustComplete()
        )
    }
}
