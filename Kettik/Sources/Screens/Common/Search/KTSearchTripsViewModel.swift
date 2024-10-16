//
//  KTSearchTripsViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import RxCocoa
import RxSwift

final class KTSearchTripsViewModel: KTViewModel {
    
    private let tripsService: KTTripsService = .init()
    private let observableTrips: BehaviorRelay<[KTTripAdapter]> = .init(value: [])
}

private extension KTSearchTripsViewModel {
    
    func search(text: String?) {
        guard
            let text = text,
            !text.isEmpty
        else { return }
        
        defaultLoading.accept(true)
        
        tripsService.rxSearchTrips(tag: text)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] trips in
                guard let self = self else { return }
                self.observableTrips.accept(trips)
                self.defaultLoading.accept(false)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    
    }
}

extension KTSearchTripsViewModel: KTViewModelProtocol {
    
    struct Input {
        let search: Observable<String?>
        let selectTrip: Observable<KTTripAdapter>
    }
    
    struct Output {
        
        let trips: Driver<[KTTripAdapter]>
    }
    
    func transform(input: Input) -> Output {
        input.search
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] text in
                self?.search(text: text)
            })
            .disposed(by: disposeBag)
        
        return .init(
            trips: observableTrips.asDriverOnErrorJustComplete()
        )
    }
}
