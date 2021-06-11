//
//  GeneralViewViewModel.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import Combine
import Foundation
import UIKit

import WidgetKit

final class GeneralViewViewModel: ObservableObject {

    struct Info: Identifiable, Equatable {
        let id = UUID()
        let icon: UIImage
        let title: String
        let subTitle: String
        let increase: Int?
        let type: CommonInfo.Info
    }

    enum LoadingState {
        case loaded, error, loading
    }

    private let remote: Remote
    private let userDefaults = UserDefaults(suiteName: "group.covid19")
    private(set) var infos: [Info] = []
    private var cancellables: [AnyCancellable] = []

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter
    }()

    @Published var commonInfo: CommonInfo? {
        didSet {
            makeInfos()
        }
    }
    @Published var state: LoadingState = .loading
    @Published var epiCurve: EpiCurve?

    var infectedIncrease: Int? {
        guard let lastInfectedRaise = epiCurve?.entries.last?.cases else {
            return nil
        }
        return lastInfectedRaise
    }

    var formattedDate: String {
        guard let info = commonInfo else {
            return ""
        }
        return dateFormatter.string(from: info.lastRefresh)
    }

    var entries: [BarChartEntry] {
        guard let epiCurveEntries = epiCurve?.entries.suffix(20) else {
            return []
        }

        return epiCurveEntries.map {
            BarChartEntry(value: $0.cases,
                          footnote: "\($0.cases)")
        }
    }

    init(remote: Remote = .shared, commonInfo: CommonInfo? = nil) {
        self.remote = remote
        self.commonInfo = commonInfo

        if commonInfo != nil {
            state = .loaded
        }
        makeInfos()
    }

    private func makeInfos() {
        guard let commonInfo = commonInfo else {
            return
        }
        var infos: [Info] = []
        for infoCase in CommonInfo.Info.allCases {
            var subTitle = ""
            var image: UIImage?
            var increase: Int?
            switch infoCase {
            case .currentInfections:
                subTitle = "\(commonInfo.currentInfections)"
                image = UIImage(systemName: "heart.fill")
            case .positives:
                subTitle = "\(commonInfo.positives)"
                image = UIImage(systemName: "bandage.fill")
                increase = infectedIncrease
            case .tests:
                subTitle = "\(commonInfo.tests)"
                image = UIImage(systemName: "t.circle")
            case .recovered:
                subTitle = "\(commonInfo.recovered)"
                image = UIImage(systemName: "staroflife.fill")
            case .dead:
                subTitle = "\(commonInfo.deadConfirmed)"
                image = UIImage(systemName: "waveform.path.ecg")
            case .availableIntensiveCareBeds:
                let percentage = Double(commonInfo.takenIntensiveBeds) / Double(commonInfo.takenIntensiveBeds + commonInfo.availableIntensiveBeds)
                subTitle = String(format: "%.1f", (100 - percentage * 100)) + "%"
                image = UIImage(systemName: "bed.double.fill")
            case .availableNormalBedsPercentage:
                let percentage = Double(commonInfo.takenNormalBeds) / Double(commonInfo.takenNormalBeds + commonInfo.availableNormalBeds)
                subTitle = String(format: "%.1f", (100 - percentage * 100)) + "%"
                image = UIImage(systemName: "bed.double.fill")
            }
            infos.append(Info(icon: image!,
                              title: infoCase.text,
                              subTitle: subTitle,
                              increase: increase,
                              type: infoCase))
        }
        self.infos = infos
    }

    private func storeWidgetInformation() {
        guard let increasedBy = infectedIncrease, let commonInfo = commonInfo else {
            return
        }
        let widgetInfo = WidgetInfo(infections: commonInfo.currentInfections,
                                    increasedBy: increasedBy)
        guard let data = try? JSONEncoder().encode(widgetInfo) else {
            return
        }
        userDefaults?.set(data, forKey: WidgetInfo.key)
        userDefaults?.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - Internal

    func reload() {
        state = .loading
        load()
    }

    func load() {
        remote.fetchProvinceTimeline().sink(receiveCompletion: { _ in }) { values in
            print(values.count)
        }
        .store(in: &cancellables)

        remote.fetchTestsAndHospitalTimeline().sink(receiveCompletion: { _ in }) { values in
            print(values.count)
        }
        .store(in: &cancellables)
    }
}
