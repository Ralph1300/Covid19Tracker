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
        case common = "https://info.gesundheitsministerium.at/data/AllgemeinDaten.csv"
        case state = "https://info.gesundheitsministerium.at/data/Bundesland.csv"
        case epiCurve = "https://info.gesundheitsministerium.at/data/Epikurve.csv"
        case provinceTimeline = "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv"
        case caseNumbersAndHospitals = "https://covid19-dashboard.ages.at/data/CovidFallzahlen.csv"

        var url: URL {
            return URL(string: self.rawValue)!
        }
    }

    func fetchCommonInformation() -> AnyPublisher<CommonInfo?, NetworkError> {
        urlSession
            .dataTaskPublisher(for: Endpoint.common.url)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8) ?? "" }
            .receive(on: DispatchQueue.main)
            .map { try? CSVParser.parseCommonInfo(from: $0) }
            .mapError { _ in NetworkError.unknown }
            .eraseToAnyPublisher()
    }

    func fetchStateInfo() -> AnyPublisher<[StateInfo], NetworkError> {
        urlSession
            .dataTaskPublisher(for: Endpoint.state.url)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8) ?? "" }
            .receive(on: DispatchQueue.main)
            .map { try? CSVParser.parseStateInfo(from: $0) }
            .replaceNil(with: [])
            .mapError { _ in NetworkError.unknown }
            .eraseToAnyPublisher()
    }

    func fetchEpiCurve() -> AnyPublisher<EpiCurve, NetworkError> {
        urlSession
            .dataTaskPublisher(for: Endpoint.epiCurve.url)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8) ?? "" }
            .receive(on: DispatchQueue.main)
            .map { try? CSVParser.parseEpiCurve(from: $0) }
            .replaceNil(with: EpiCurve(dateStamp: Date(), entries: []))
            .mapError { _ in NetworkError.unknown }
            .eraseToAnyPublisher()
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
