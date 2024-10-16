//
//  KTTripDifficulty.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import UIKit

enum KTTripDifficulty: String {
    
    case hard
    case easy
    case medium
}

extension KTTripDifficulty {
    
    var title: String {
        switch self {
        case .hard: return KTStrings.Trip.Difficulty.hard
        case .easy: return KTStrings.Trip.Difficulty.easy
        case .medium: return KTStrings.Trip.Difficulty.medium
        }
    }
    
    var color: UIColor {
        switch self {
        case .hard: return KTColors.TripDifficulty.hard.color
        case .easy: return KTColors.TripDifficulty.easy.color
        case .medium: return KTColors.TripDifficulty.medium.color
        }
    }
}
