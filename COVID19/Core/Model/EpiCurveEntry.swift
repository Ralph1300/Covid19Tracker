//
//  EpiCurveEntry.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 13.09.20.
//

import Foundation

struct EpiCurve {
    let dateStamp: Date
    let entries: [EpiCurveEntry]
}

struct EpiCurveEntry {
    let day: Date
    let cases: Int
}
