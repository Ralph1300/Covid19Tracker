//
//  CSVParsable.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 14.11.20.
//

import Foundation

protocol CSVParsable {
    init(dict: [String: Any], parser: NewCSVParser) throws
}

final class NewCSVParser {

    enum ParsingError: Error {
        case unknown
        case empty
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()

    func parse<T: CSVParsable>(data: String) throws -> [T] {
        let lineBreakType = lineBreakType(for: data)
        let allRows = Array(data.split(separator: lineBreakType.modifier))
        guard let header = allRows.first?.split(separator: ";") else {
            throw ParsingError.empty
        }
        let rows = allRows.dropFirst()
        var objects: [T] = []
        for row in rows {
            var dict: [String: Any] = [:]
            for (header, data) in zip(header, row.split(separator: ";")) {
                dict[String(header)] = data
            }
            let object = try T(dict: dict, parser: self)
            objects.append(object)
        }
        return objects
    }

    func convertToInt(value: Any?) -> Int {
        guard let valueAsNSString = value as? NSString else {
            return 0
        }
        return Int(valueAsNSString as String) ?? 0
    }

    func convertToDouble(value: Any?) -> Double {
        guard let valueAsNSString = value as? NSString else {
            return 0
        }
        let correctFloatingPointString = (valueAsNSString as String).replacingOccurrences(of: ",", with: ".")
        return Double(correctFloatingPointString) ?? 0
    }

    func convertToDate(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    private enum LineBreakType {
        case mac
        case windows
        
        var modifier: Character {
            switch self {
            case .mac:
                return "\n"
            case .windows:
                return "\r\n"
            }
        }
    }
    
    private func lineBreakType(for data: String) -> LineBreakType {
        if data.contains(LineBreakType.windows.modifier) {
            return .windows
        }
        return .mac
    }
}
