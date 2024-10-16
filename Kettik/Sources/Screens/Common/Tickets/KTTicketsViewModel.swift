//
//  KTTicketViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import RxCocoa
import RxSwift

final class KTTicketsViewModel: KTViewModel {
    
    private let usersService: KTUsersService = .init()
    
    private let observableTickets: BehaviorRelay<[KTTicketAdapter]> = .init(value: [])
}

private extension KTTicketsViewModel {
    
    func loadTickets() {
        defaultLoading.accept(true)
        
        usersService.rxGetTickets()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] tickets in
                guard let self = self else { return }
                self.observableTickets.accept(tickets)
                self.defaultLoading.accept(false)
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.show(error: nil)
                self.defaultLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}

extension KTTicketsViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let loadData: Observable<Void>
        let selectTicket: Observable<KTTicketAdapter>
    }
    
    struct Output {
        
        let tickets: Driver<[KTTicketAdapter]>
    }

    func transform(input: Input) -> Output {
        input.loadData
            .bind(onNext: { [unowned self] in
                loadTickets()
            })
            .disposed(by: disposeBag)
        
        input.selectTicket
            .map { KTTicketScreen(ticket: $0) }
            .map { PresentViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPresentViewController)
            .disposed(by: disposeBag)
        
        return .init(
            tickets: observableTickets.asDriverOnErrorJustComplete()
        )
    }
}
