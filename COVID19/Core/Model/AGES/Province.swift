//
//  Province.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import Foundation

enum Province: Int {
    case burgenland = 1, carinthia, lowerAustria, upperAustria, salzburg, styria, vorarlberg, vienna, austria

    var provinceName: String {
        switch self {
        case .austria:
            return "Österreich"
        case .burgenland:
            return "Burgenland"
        case .carinthia:
            return "Kärnten"
        case .lowerAustria:
            return "Niederösterreich"
        case .salzburg:
            return "Salzburg"
        case .styria:
            return "Steiermark"
        case .upperAustria:
            return "Oberösterreich"
        case .vienna:
            return "Wien"
        case .vorarlberg:
            return "Vorarlberg"
        }
    }
}
