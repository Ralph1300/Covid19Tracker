//
//  CSVParser.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 21.08.20.
//

import Foundation

final class CSVParser {

    private init() { }

    enum ParsingError: Error {
        case cannotParse
        case noData
    }

    private static let dateStampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "DD.MM.yyyy"
        return dateFormatter
    }()

    // MARK: - CommonInfo

    static func parseStateInfo(from csv: String) throws -> [StateInfo] {
        let dataRows = Array(csv.split(separator: "\n").dropFirst())

        return dataRows.map {
            let splitData = String($0).split(separator: ";")
            return StateInfo(name: String(splitData[0]),
                             activeCases: Int(splitData[1]) ?? 0,
                             gkz: Int(splitData[2]) ?? 0,
                             dateStamp: dateStampFormatter.date(from: String(splitData[3])) ?? Date())
        }
    }

    // MARK: - Common Info

    static func parseCommonInfo(from csv: String) throws -> CommonInfo {
        guard let dataRow = Array(csv.split(separator: "\n").dropFirst()).first else {
            throw ParsingError.noData
        }
        let splitData = String(dataRow).split(separator: ";")
        return CommonInfo(currentInfections: Int(splitData[0]) ?? 0,
                          positives: Int(splitData[1]) ?? 0,
                          recovered: Int(splitData[2]) ?? 0,
                          deadConfirmed: Int(splitData[3]) ?? 0,
                          deadAnnounced: Int(splitData[4]) ?? 0,
                          tests: Int(splitData[5]) ?? 0,
                          confirmedCases: Int(splitData[6]) ?? 0,
                          availableNormalBeds: Int(splitData[7]) ?? 0,
                          availableIntensiveBeds: Int(splitData[8]) ?? 0,
                          takenNormalBeds: Int(splitData[9]) ?? 0,
                          takenIntensiveBeds: Int(splitData[10]) ?? 0,
                          nonHospitalisedCases: Int(splitData[11]) ?? 0,
                          sickCases: Int(splitData[12]) ?? 0,
                          lastRefresh: dateStampFormatter.date(from: String(splitData.last ?? "")) ?? Date())
    }

    // MARK: - EpiCurve

    static func parseEpiCurve(from csv: String) throws -> EpiCurve {
        let dataRows = Array(csv.split(separator: "\n").dropFirst())
        let dateStamp = dateStampFormatter
            .date(from: String(dataRows.first?.split(separator: ";")[2] ?? "")) ?? Date()
        let entries: [EpiCurveEntry] = dataRows.map {
            let splitData = String($0).split(separator: ";")
            let day = createDate(from: String(splitData[0]))
            return EpiCurveEntry(day: day,
                                 cases: Int(splitData[1]) ?? 0)
        }
        return EpiCurve(dateStamp: dateStamp, entries: entries)
    }

    private static func createDate(from text: String) -> Date {
        let split = text.split(separator: ".")
        guard let day = Int(split[0]),
              let month = Int(split[1]),
              let year = Int(split[2]) else {
            return Date()
        }
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(identifier: "GMT")
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.hour = 0
        dateComponents.second = 0
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
