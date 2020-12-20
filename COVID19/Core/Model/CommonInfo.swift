//
//  CommonInfo.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 21.08.20.
//

import Foundation

struct CommonInfo {

    enum Info: CaseIterable {
        case currentInfections
        case positives
        case tests
        case recovered
        case dead
        case availableNormalBedsPercentage
        case availableIntensiveCareBeds

        var text: String {
            switch self {
            case .currentInfections:
                return "Aktive Fälle"
            case .positives:
                return "Positive Tests"
            case .tests:
                return "Durchgeführte Tests"
            case .recovered:
                return "Genesen"
            case .dead:
                return "Verstorben"
            case .availableNormalBedsPercentage:
                return "Verfügbare Krankenhausbetten"
            case .availableIntensiveCareBeds:
                return "Verfügbare Intensivbetten"
            }
        }
    }

    let currentInfections: Int
    let positives: Int
    let recovered: Int
    let deadConfirmed: Int
    let deadAnnounced: Int
    let tests: Int
    let confirmedCases: Int
    let availableNormalBeds: Int
    let availableIntensiveBeds: Int
    let takenNormalBeds: Int
    let takenIntensiveBeds: Int
    let nonHospitalisedCases: Int
    let sickCases: Int
    let lastRefresh: Date

    static func stub() -> CommonInfo {
        return CommonInfo(currentInfections: 1000,
                          positives: 100,
                          recovered: 100,
                          deadConfirmed: 100,
                          deadAnnounced: 100,
                          tests: 40000,
                          confirmedCases: 100,
                          availableNormalBeds: 9,
                          availableIntensiveBeds: 10,
                          takenNormalBeds: 8,
                          takenIntensiveBeds: 8,
                          nonHospitalisedCases: 8,
                          sickCases: 100,
                          lastRefresh: Date())
    }
}
