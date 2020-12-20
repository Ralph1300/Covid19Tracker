//
//  ProvinceTimelineInformation.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import Foundation

struct ProvinceTimelineInformation: CSVParsable {

    let time: String
    let province: Province
    let provinceId: Int
    let inhabitantCount: Int
    let cases: Int
    let totalCases: Int
    let cases7Day: Int
    let incidence7Days: Double
    let dailyDeaths: Int
    let totalDeaths: Int
    let dailyHealed: Int
    let totalHealed: Int

    init(dict: [String: Any], parser: NewCSVParser) throws {
        self.time = (dict["Time"] as? NSString ?? "") as String
        self.province = Province(rawValue: parser.convertToInt(value: dict["BundeslandID"])) ?? .austria
        self.provinceId = parser.convertToInt(value: dict["BundeslandID"])
        self.inhabitantCount = parser.convertToInt(value: dict["AnzEinwohner"])
        self.cases = parser.convertToInt(value: dict["AnzahlFaelle"])
        self.totalCases = parser.convertToInt(value: dict["AnzahlFaelleSum"])
        self.cases7Day = parser.convertToInt(value: dict["AnzahlFaelle7Tage"])
        self.incidence7Days = parser.convertToDouble(value: dict["SiebenTageInzidenzFaelle"])
        self.dailyDeaths = parser.convertToInt(value: dict["AnzahlTotTaeglich"])
        self.totalDeaths = parser.convertToInt(value: dict["AnzahlTotSum"])
        self.dailyHealed = parser.convertToInt(value: dict["AnzahlGeheiltTaeglich"])
        self.totalHealed = parser.convertToInt(value: dict["AnzahlGeheiltSum"])
    }

    init(time: String, province: Province, inhabitantCount: Int, cases: Int, totalCases: Int, cases7Day: Int, incidence7Days: Double, dailyDeaths: Int, totalDeaths: Int, dailyHealed: Int, totalHealed: Int ) {
        self.time = time
        self.province = province
        self.provinceId = province.rawValue
        self.inhabitantCount = inhabitantCount
        self.cases = cases
        self.totalCases = totalCases
        self.cases7Day = cases7Day
        self.incidence7Days = incidence7Days
        self.dailyDeaths = dailyDeaths
        self.totalDeaths = totalDeaths
        self.dailyHealed = dailyHealed
        self.totalHealed = totalHealed
    }

    static func stub() -> ProvinceTimelineInformation {
        return ProvinceTimelineInformation(time: "05.12.2020: 00:00:00",
                                           province: .austria,
                                           inhabitantCount: 10,
                                           cases: 2500,
                                           totalCases: 10_000,
                                           cases7Day: 50,
                                           incidence7Days: 250,
                                           dailyDeaths: 100,
                                           totalDeaths: 3500,
                                           dailyHealed: 2500,
                                           totalHealed: 100_000)
    }
}
