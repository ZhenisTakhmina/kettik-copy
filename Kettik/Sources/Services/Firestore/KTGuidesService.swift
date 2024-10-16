//
//  KTGuidesService.swift
//  Kettik
//
//  Created by Tami on 02.05.2024.
//

import RxSwift
import RxCocoa

final class KTGuidesService: KTFirebaseServiceType {
    
    var collection: String {
        "guides"
    }
}

extension KTGuidesService {
    
    func rxGetGuides() -> Single<[KTGuideAdapter]> {
        rxGetDocuments()
            .map { documents in
                let guides: [KTGuideAdapter] = documents
                    .compactMap { KTGuide(documentSnapshot: $0) }
                    .map { .init(guide: $0) }
                
                return guides
            }
    }
}
