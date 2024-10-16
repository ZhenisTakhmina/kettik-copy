//
//  KTDataService.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import Foundation
import RxCocoa
import RxSwift

final class KTDataService {
    
    private enum Constants {
        
        static let favouritesKey: String = "KTDataService.favourites"
    }
    
    private let tripsQueue: DispatchQueue = .init(label: "kz.kettik.dataservice.tripsqueue", attributes: .concurrent)
    private let favouritesQueue: DispatchQueue = .init(label: "kz.kettik.dataservice.favouritesqueue", attributes: .concurrent)
    
    private var trips: [String: KTTrip] = [:]
    private var favourites: [String] = []
}

extension KTDataService {
    
    func set(trip: KTTrip) {
        tripsQueue.async(flags: .barrier, execute: { [weak self] in
            self?.trips[trip.id] = trip
        })
    }
    
    func getTrip(id: String) -> KTTrip? {
        trips[id]
    }
}

extension KTDataService {
    
    func getFavourites() -> [String] {
        favourites
    }
    
    func isFavourite(tripId: String) -> Bool {
        favourites.contains(tripId)
    }
    
    func rxAddToFavourite(tripId: String) -> Single<Void> {
        guard !favourites.contains(tripId) else {
            return .just(())
        }
        
        return Single<Void>.create { [unowned self] single in
            favouritesQueue.async(flags: .barrier, execute: { [unowned self] in
                favourites.append(tripId)
                UserDefaults.standard.set(favourites, forKey: Constants.favouritesKey)
                single(.success(()))
            })
            
            return Disposables.create()
        }
    }
    
    func rxRemoveFromFavourite(tripId: String) -> Single<Void> {
        return Single<Void>.create { [unowned self] single in
            favouritesQueue.async(flags: .barrier, execute: { [unowned self] in
                favourites.removeAll(where: { $0 == tripId })
                UserDefaults.standard.set(favourites, forKey: Constants.favouritesKey)
                single(.success(()))
            })
            
            return Disposables.create()
        }
    }
}

extension KTDataService: KTSplashLoadable {
    
    func loadInitialData(_ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            let favourites: [String] = UserDefaults.standard.array(forKey: Constants.favouritesKey) as? [String] ?? []
            
            DispatchQueue.main.async { [unowned self] in
                self.favourites = favourites
                completion()
            }
        }
    }
}
