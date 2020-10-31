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
}
