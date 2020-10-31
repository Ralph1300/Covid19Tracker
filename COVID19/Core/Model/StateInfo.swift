//
//  StateInfo.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import Foundation

struct StateInfo: Identifiable {
    let id = UUID()
    let name: String
    let activeCases: Int
    let gkz: Int
    let dateStamp: Date

    static func stub() -> StateInfo {
        return StateInfo(name: "Oberösterreich", activeCases: 400, gkz: 123, dateStamp: Date())
    }
}
