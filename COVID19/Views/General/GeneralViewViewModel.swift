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
        let type: TimelineStates.InfoType
    }

    enum LoadingState {
        case loaded, error, loading
    }

    private let remote: Remote
    private let userDefaults = UserDefaults(suiteName: "group.covid19")
    private(set) var infos: [Info] = []
    private var timelines: [TimelineStates] = []
    private var cancellables: [AnyCancellable] = []

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter
    }()

    @Published var timeline: TimelineStates? {
        didSet {
            state = timeline == nil ? .error : .loaded
            makeInfos()
        }
    }
    @Published var state: LoadingState = .loading

    var infectedIncrease: Int?

    var formattedDate: String {
        guard let info = timeline else {
            return ""
        }
        return dateFormatter.string(from: info.date)
    }

    init(remote: Remote = .shared, timeline: TimelineStates? = nil) {
        self.remote = remote
        self.timeline = timeline

        if timeline != nil {
            state = .loaded
        }
        makeInfos()
    }

    private func makeInfos() {
        guard let timeline = timeline else {
            return
        }
        var infos: [Info] = []
        for infoCase in TimelineStates.InfoType.allCases {
            var subTitle = ""
            var image: UIImage?
            var increase: Int?
            switch infoCase {
            case .cases:
                subTitle = "\(timeline.confirmedCases)"
                image = UIImage(systemName: "heart.fill")
                increase = infectedIncrease
            case .recovered:
                subTitle = "\(timeline.recovered)"
                image = UIImage(systemName: "bandage.fill")
            case .tests:
                subTitle = "\(timeline.tests)"
                image = UIImage(systemName: "t.circle")
            case .deaths:
                subTitle = "\(timeline.deaths)"
                image = UIImage(systemName: "staroflife.fill")
            case .intenseCare:
                subTitle = "\(timeline.intensiveCare)"
                image = UIImage(systemName: "waveform.path.ecg")
            case .hospitalized:
                subTitle = "\(timeline.hospitalized)"
                image = UIImage(systemName: "waveform.path.ecg")
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
        guard let timeline = timeline else {
            return
        }
        let widgetInfo = WidgetInfo(infections: timeline.confirmedCases,
                                    increasedBy: 100) // TODO
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
        remote.fetchStateTimeline().sink(receiveCompletion: { _ in }) { [weak self] timelines in
            let latestAustriaTimeLine = timelines.last // austria is always at the last position
            let secondToLastAustriaTimeLine = timelines.dropLast().last(where: { $0.province == .austria })
            
            if let lastIncrease = latestAustriaTimeLine?.confirmedCases,
               let secondToLastIncrease = secondToLastAustriaTimeLine?.confirmedCases {
                self?.infectedIncrease = lastIncrease - secondToLastIncrease
            }
            self?.timeline = latestAustriaTimeLine
        }
        .store(in: &cancellables)
        
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
