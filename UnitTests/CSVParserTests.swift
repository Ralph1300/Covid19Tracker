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
    }

    func testParseStateInformation() throws {
    }

    func testParseEpiCurve() throws {
    }

    // MARK - Helper

    private func loadData(from fileName: String) -> String? {
        guard let filePath = testBundle.url(forResource: fileName, withExtension: "csv") else {
            return nil
        }
        return try? String(contentsOf: filePath)
    }
}
