//
//  TestAndHospitalTimelineInformation.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import Foundation

struct TestAndHospitalTimelineInformation: CSVParsable {
    let time: String
    let testCount: Int
    let date: String
    let hospitalised: Int
    let icuHospitalised: Int
    let hospitalBedsFree: Int
    let icuBedsFree: Int
    let provinceId: Int
    let province: Province

    var bedsFreePercentage: String {
        let percentage = Double(hospitalised) / Double(hospitalised + hospitalBedsFree)
        return String(format: "%.1f", (100 - percentage * 100)) + "%"
    }

    var icuBedsFreePercentage: String {
        let percentage = Double(icuHospitalised) / Double(icuHospitalised + icuBedsFree)
        return String(format: "%.1f", (100 - percentage * 100)) + "%"
    }

    init(dict: [String: Any], parser: NewCSVParser) throws {
        self.time = (dict["Meldedat"] as? NSString ?? "") as String
        self.province = Province(rawValue: parser.convertToInt(value: dict["BundeslandID"])) ?? .austria
        self.provinceId = parser.convertToInt(value: dict["BundeslandID"])
        self.testCount = parser.convertToInt(value: dict["TestGesamt"])
        self.date = (dict["MeldeDatum"] as? NSString ?? "") as String
        self.hospitalised = parser.convertToInt(value: dict["FZHosp"])
        self.icuHospitalised = parser.convertToInt(value: dict["FZICU"])
        self.hospitalBedsFree = parser.convertToInt(value: dict["FZHospFree"])
        self.icuBedsFree = parser.convertToInt(value: dict["FZICUFree"])
    }

    init(time: String,
         testCount: Int,
         date: String,
         hospitalised: Int,
         icuHospitalised: Int,
         hospitalBedsFree: Int,
         icuBedsFree: Int,
         province: Province) {
        self.time = time
        self.testCount = testCount
        self.date = date
        self.hospitalised = hospitalised
        self.icuHospitalised = icuHospitalised
        self.hospitalBedsFree = hospitalBedsFree
        self.icuBedsFree = icuBedsFree
        self.provinceId = province.rawValue
        self.province = province
    }

    static func stub() -> TestAndHospitalTimelineInformation {
        return TestAndHospitalTimelineInformation(time: "07.12.2020",
                                                  testCount: 320_000,
                                                  date: "07.12.2020 00:00:00",
                                                  hospitalised: 200,
                                                  icuHospitalised: 100,
                                                  hospitalBedsFree: 1500,
                                                  icuBedsFree: 800,
                                                  province: .austria)
    }
}
