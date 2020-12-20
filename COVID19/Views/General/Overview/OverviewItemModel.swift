//
//  OverviewItemModel.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 07.12.20.
//

import Foundation

struct OverviewItemModel: Identifiable {
    let id = UUID()

    let province: Province
    let newCases: Int
    let totalCases: Int
    let sevenDayIncidence: Double
    let deaths: Int
    let healthy: Int
    let totalDeaths: Int
    let normalBedString: String
    let changeNormalBeds: Double
    let icuBedString: String
    let changeIcuBeds: Double

    var icuTrend: Trend {
        if changeIcuBeds > 0 {
            return .high(percentage: changeIcuBeds)
        }
        return .low(percentage: changeIcuBeds)
    }

    var formattedSevenDayIncidence: String {
        return String(format: "%.1f", sevenDayIncidence)
    }
    
    static func stub() -> OverviewItemModel {
        return OverviewItemModel(province: .austria,
                                 newCases: 4500,
                                 totalCases: 20_000,
                                 sevenDayIncidence: 75,
                                 deaths: 112,
                                 healthy: 2000,
                                 totalDeaths: 3500,
                                 normalBedString: "50%",
                                 changeNormalBeds: 3.5,
                                 icuBedString: "20%",
                                 changeIcuBeds: 4.5)
    }
}
