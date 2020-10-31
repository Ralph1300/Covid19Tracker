//
//  StateViewModel.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 05.09.20.
//

import Combine
import Foundation

final class StateViewModel: ObservableObject {
    private let remote: Remote

    @Published var stateInfos: [StateInfo]

    private var cancellable: Cancellable?

    var formattedDate: String {
        guard let info = stateInfos.first else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: info.dateStamp)
    }

    init(remote: Remote = .shared, stateInfos: [StateInfo] = []) {
        self.remote = remote
        self.stateInfos = stateInfos
    }

    func load() {
        cancellable = remote
            .fetchStateInfo()
            .replaceError(with: [])
            .map { info in info.sorted(by: { $0.activeCases > $1.activeCases })}
            .assign(to: \.stateInfos, on: self)
    }
}
