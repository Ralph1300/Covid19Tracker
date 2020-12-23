//
//  Province.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import Foundation

enum Province: Int {
    case burgenland = 1
    case carinthia = 2
    case lowerAustria = 3
    case upperAustria = 4
    case salzburg = 5
    case styria = 6
    case tyrol = 7
    case vorarlberg = 8
    case vienna = 9
    case austria = 10

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
        case .tyrol:
            return "Tirol"
        case .vienna:
            return "Wien"
        case .vorarlberg:
            return "Vorarlberg"
        }
    }
}
