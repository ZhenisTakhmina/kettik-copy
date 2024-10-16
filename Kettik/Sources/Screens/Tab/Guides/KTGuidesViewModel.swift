//
//  KTGuidesViewModel.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import RxSwift
import RxCocoa

final class KTGuidesViewModel: KTViewModel {
    
    private let guidesService: KTGuidesService = .init()
    
    private let observableGuides: BehaviorRelay<[KTGuideAdapter]> = .init(value: [])
}

private extension KTGuidesViewModel {
    
    func loadData() {
        defaultLoading.accept(true)
        
        guidesService.rxGetGuides()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] guides in
                guard let self = self else { return }
                self.observableGuides.accept(guides)
                self.defaultLoading.accept(false)
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.show(error: nil)
                self.defaultLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}

extension KTGuidesViewModel: KTViewModelProtocol {
    
    struct Input {
        
        let loadData: Observable<Void>
        let selectGuide: Observable<KTGuideAdapter>
    }
    
    struct Output {
        
        let guides: Driver<[KTGuideAdapter]>
    }
    
    func transform(input: Input) -> Output {
        input.loadData
            .bind(onNext: { [unowned self] in
                loadData()
            })
            .disposed(by: disposeBag)
        
        input.selectGuide
            .map { KTGuideDetailsScreen(guide: $0) }
            .map { PushViewControllerConfiguration(controller: $0, animated: true) }
            .bind(to: defaultPushViewController)
            .disposed(by: disposeBag)
        
        return .init(
            guides: observableGuides.asDriverOnErrorJustComplete()
        )
    }
}
