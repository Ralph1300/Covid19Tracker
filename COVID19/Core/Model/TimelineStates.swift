//
//  TimelineStates.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 14.06.21.
//

import Foundation

struct TimelineStates: CSVParsable {
    
    let date: Date
    let province: Province
    let confirmedCases: Int
    let deaths: Int
    let recovered: Int
    let hospitalized: Int
    let intensiveCare: Int
    let tests: Int
    let pcrTests: Int
    let antigenTests: Int
    
    init(date: Date, province: Province, confirmedCases: Int, deaths: Int, recovered: Int, hospitalized: Int, intensiveCare: Int, tests: Int, pcrTests: Int, antigenTests: Int) {
        self.date = date
        self.province = province
        self.confirmedCases = confirmedCases
        self.deaths = deaths
        self.recovered = recovered
        self.hospitalized = hospitalized
        self.intensiveCare = intensiveCare
        self.tests = tests
        self.pcrTests = pcrTests
        self.antigenTests = antigenTests
    }
    
    init(dict: [String : Any], parser: NewCSVParser) throws {
        self.date = Date()
        self.province = Province(rawValue: parser.convertToInt(value: dict["BundeslandID"])) ?? .austria
        self.confirmedCases = parser.convertToInt(value: dict["BestaetigteFaelleBundeslaender"])
        self.deaths = parser.convertToInt(value: dict["Todesfaelle"])
        self.recovered = parser.convertToInt(value: dict["Genesen"])
        self.hospitalized = parser.convertToInt(value: dict["Hospitalisierung"])
        self.intensiveCare = parser.convertToInt(value: dict["Intensivstation"])
        self.tests = parser.convertToInt(value: dict["Testungen"])
        self.pcrTests = parser.convertToInt(value: dict["TestungenPCR"])
        self.antigenTests = parser.convertToInt(value: dict["TestungenAntigen"])
    }
}
