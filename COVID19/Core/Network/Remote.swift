//
//  Remote.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 21.08.20.
//

import Combine
import Foundation

final class Remote {

    static let shared = Remote()

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    enum NetworkError: Error {
        case notReachable
        case unknown
    }

    enum Endpoint: String {
        case provinceTimeline = "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv"
        case caseNumbersAndHospitals = "https://covid19-dashboard.ages.at/data/CovidFallzahlen.csv"
        case numbersForState = "https://info.gesundheitsministerium.gv.at/data/timeline-faelle-bundeslaender.csv"

        var url: URL {
            return URL(string: self.rawValue)!
        }
    }

    func fetchProvinceTimeline() -> AnyPublisher<[ProvinceTimelineInformation], NetworkError> {
        return makePublisher(for: .provinceTimeline)
    }

    func fetchTestsAndHospitalTimeline() -> AnyPublisher<[TestAndHospitalTimelineInformation], NetworkError> {
        return makePublisher(for: .caseNumbersAndHospitals)
    }

    // MARK: - Private

    private func makePublisher<T: CSVParsable>(for endpoint: Endpoint) -> AnyPublisher<[T], NetworkError> {
        urlSession
            .dataTaskPublisher(for: endpoint.url)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8) ?? "" }
            .receive(on: DispatchQueue.main)
            .map { try? NewCSVParser().parse(data: $0) }
            .replaceNil(with: [])
            .mapError { _ in NetworkError.unknown }
            .eraseToAnyPublisher()
    }
}
