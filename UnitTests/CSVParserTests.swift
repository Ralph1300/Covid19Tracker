//
//  CSVParserTests.swift
//  UnitTests
//
//  Created by Ralph Schnalzenberger on 21.08.20.
//

import XCTest

final class CSVParserTests: XCTestCase {

    private let testBundle = Bundle(for: CSVParserTests.self)

    func testParseCommonInfoString() throws {
        let testString = try XCTUnwrap(loadData(from: "commonData"))
        let parsedObject = try CSVParser.parseCommonInfo(from: testString)
        XCTAssertEqual(parsedObject.currentInfections, 2772)
        XCTAssertEqual(parsedObject.positives, 24846)
        XCTAssertEqual(parsedObject.recovered, 21260)
        XCTAssertEqual(parsedObject.deadConfirmed, 725)
        XCTAssertEqual(parsedObject.deadAnnounced, 730)
        XCTAssertEqual(parsedObject.tests, 1075409)
        XCTAssertEqual(parsedObject.confirmedCases, 24762)
        XCTAssertEqual(parsedObject.availableNormalBeds, 7373)
        XCTAssertEqual(parsedObject.availableIntensiveBeds, 727)
        XCTAssertEqual(parsedObject.takenNormalBeds, 90)
        XCTAssertEqual(parsedObject.takenIntensiveBeds, 22)
        XCTAssertEqual(parsedObject.nonHospitalisedCases, 2660)
        XCTAssertEqual(parsedObject.sickCases, 24846)
        XCTAssertEqual(parsedObject.lastRefresh, Date(timeIntervalSinceReferenceDate: 619725600))
    }

    func testParseStateInformation() throws {
        let testString = try XCTUnwrap(loadData(from: "states"))
        let stateInfos = try CSVParser.parseStateInfo(from: testString)

        XCTAssertEqual(stateInfos.count, 9)

        let firstStateInfo = try XCTUnwrap(stateInfos.first)

        XCTAssertEqual(firstStateInfo.name, "Wien")
        XCTAssertEqual(firstStateInfo.activeCases, 1726)
        XCTAssertEqual(firstStateInfo.gkz, 9)
        XCTAssertEqual(firstStateInfo.dateStamp, Date(timeIntervalSince1970: 1598706000))
    }

    func testParseEpiCurve() throws {
        let testString = try XCTUnwrap(loadData(from: "Epikurve"))
        let epiCurve = try CSVParser.parseEpiCurve(from: testString)

        XCTAssertEqual(epiCurve.dateStamp, Date(timeIntervalSinceReferenceDate: 619725600))
        XCTAssertEqual(epiCurve.entries.count, 201)

        XCTAssertEqual(epiCurve.entries.first?.cases, 2)
        XCTAssertEqual(epiCurve.entries.first?.day,
                       Date(timeIntervalSince1970: 1582588800))

    }

    // MARK - Helper

    private func loadData(from fileName: String) -> String? {
        guard let filePath = testBundle.url(forResource: fileName, withExtension: "csv") else {
            return nil
        }
        return try? String(contentsOf: filePath)
    }
}
