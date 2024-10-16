//
//  KTOrderViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import Foundation
import RxCocoa
import RxSwift

final class KTOrderViewModel: KTViewModel {
    
    private let usersService: KTUsersService = .init()
    
    private let trip: KTTripAdapter
    private let observableName: BehaviorRelay<String?> = .init(value: nil)
    private let observablePhoneNumber: BehaviorRelay<String?> = .init(value: nil)
    private let totalCount: BehaviorRelay<Int> = .init(value: 1)
    private lazy var totalPrice: BehaviorRelay<Int> = .init(value: trip.price ?? 0)
    private let showPending: PublishRelay<Void> = .init()
    
    private let onSuccess: ((KTTicketAdapter) -> Void)
    
    init(trip: KTTripAdapter, onSuccess: @escaping ((KTTicketAdapter) -> Void)) {
        self.trip = trip
        self.onSuccess = onSuccess
        super.init()
    }
}

private extension KTOrderViewModel {
    
    func handleDecCount() {
        
        var count: Int = totalCount.value
        guard count > 1 else { return }
        count -= 1
        totalCount.accept(count)
        totalPrice.accept(count * (trip.price ?? 0))
    }
    
    func handleIncCount() {
        
        var count: Int = totalCount.value
        count += 1
        totalCount.accept(count)
        totalPrice.accept(count * (trip.price ?? 0))
    }
    
    func order() {
        defaultLoading.accept(true)
        
        usersService.rxBuyTickets(
            name: observableName.value ?? "",
            phoneNumber: observablePhoneNumber.value ?? "",
            count: totalCount.value,
            totalPrice: totalPrice.value,
            trip: trip
        )
            .subscribe(onSuccess: { [weak self] ticket in
                guard let self = self else { return }
                self.showPending.accept(())
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                    guard let self = self else { return }
                    self.defaultDismissViewController.accept(.init(animated: true, completion: { [weak self] in
                        self?.onSuccess(ticket)
                    }))
                })
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.defaultLoading.accept(false)
                self.show(error: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension KTOrderViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let name: Observable<String>
        let phoneNumber: Observable<String>
        let decCount: Observable<Void>
        let incCount: Observable<Void>
        let order: Observable<Void>
    }
    
    struct Output {
        
        let trip: Driver<KTTripAdapter>
        let totalCount: Driver<Int>
        let totalPrice: Driver<Int>
        let showPending: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.name
            .bind(to: observableName)
            .disposed(by: disposeBag)
        
        input.phoneNumber
            .bind(to: observablePhoneNumber)
            .disposed(by: disposeBag)
        
        input.decCount
            .bind(onNext: { [unowned self] in
                handleDecCount()
            })
            .disposed(by: disposeBag)
        
        input.incCount
            .bind(onNext: { [unowned self] in
                handleIncCount()
            })
            .disposed(by: disposeBag)
        
        input.order
            .bind(onNext: { [unowned self] in
                order()
            })
            .disposed(by: disposeBag)
        
        return .init(
            trip: .just(trip),
            totalCount: totalCount.asDriverOnErrorJustComplete(),
            totalPrice: totalPrice.asDriverOnErrorJustComplete(),
            showPending: showPending.asDriverOnErrorJustComplete()
        )
    }
}
