//
//  WidgetInfo.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 01.11.20.
//

import Foundation

struct WidgetInfo: Codable {
    static let key = "WidgetInfo"

    let infections: Int
    let increasedBy: Int
}
