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
    @Published var timelineInfos: [OverviewItemModel] = []

    private var cancellable: Cancellable?

    init(remote: Remote = .shared, timelineInfos: [OverviewItemModel] = []) {
        self.remote = remote
        self.timelineInfos = timelineInfos
    }

    func load() {
        cancellable = Publishers.Zip(remote.fetchProvinceTimeline(),
                                     remote.fetchTestsAndHospitalTimeline())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { (timelines, testAndHospitalInfos) in
                    self.timelineInfos = self.makeOverviewModels(from: timelines, and: testAndHospitalInfos)
            })
    }

    private func makeOverviewModels(from timelines: [ProvinceTimelineInformation], and hospitalNumbers: [TestAndHospitalTimelineInformation]) -> [OverviewItemModel] {
        let last10ProvinceModels = Array(timelines.suffix(10)).filter { $0.province != .austria }
        let hospitalNumberToCompare = Array(hospitalNumbers.suffix(20).prefix(10)).filter { $0.province != .austria }
        let last10HospitalModels = Array(hospitalNumbers.suffix(10)).filter { $0.province != .austria }

        var models: [OverviewItemModel] = []
        for (province, hospital) in zip(last10ProvinceModels, last10HospitalModels) {
            guard let elementToCompare = hospitalNumberToCompare.first(where: { $0.province == province.province }) else {
                continue
            }

            let changeICUInTotal = Double(hospital.icuHospitalised) - Double(elementToCompare.icuHospitalised)
            let relativeICUChange = changeICUInTotal / Double(elementToCompare.icuHospitalised) * 100
            models.append(OverviewItemModel(province: province.province,
                                            newCases: province.cases,
                                            totalCases: province.totalCases,
                                            sevenDayIncidence: province.incidence7Days,
                                            deaths: province.dailyDeaths,
                                            healthy: province.dailyHealed,
                                            totalDeaths: province.totalDeaths,
                                            normalBedString: hospital.bedsFreePercentage,
                                            changeNormalBeds: -1, // not used
                                            icuBedString: hospital.icuBedsFreePercentage,
                                            changeIcuBeds: relativeICUChange))
        }

        return models
    }
}
