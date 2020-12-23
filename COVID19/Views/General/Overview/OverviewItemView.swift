//
//  OverviewItemView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import SwiftUI

enum Trend {
    case high(percentage: Double)
    case low(percentage: Double)
}

enum RowInfoTextType {
    case trend(trend: Trend)
    case info(text: String)
}

struct OverviewItemView: View {
    let model: OverviewItemModel
    let didTap: (OverviewItemModel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.province.provinceName)
                .font(.title)
                .bold()
                .foregroundColor(Color(.label))
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary)
                    .opacity(1)
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fälle", systemImage: "bandage.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                    HorizontalInfoView(infos: makeFirstRowInfos())
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 1)
                    Label("Allgemein", systemImage: "waveform.path.ecg")
                        .font(.headline)
                        .foregroundColor(.white)
                    HorizontalInfoView(infos: makeSecondRowInfos())
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(height: 1)
                    Label("Hospitalisierung", systemImage: "bed.double.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                    HorizontalInfoView(infos: makeThirdRowInfos())
                }
                .padding(.all, 8)
            }
            .fixedSize(horizontal: false, vertical: true)
            .onTapGesture {
                didTap(model)
            }
        }
        .padding(.horizontal)
    }


    private func makeFirstRowInfos() -> [RowInfo] {
        return [RowInfo(title: "Neu", info: .info(text: "\(model.newCases)")),
                RowInfo(title: "Total", info: .info(text: "\(model.totalCases)")),
                RowInfo(title: "7-Tage-Inzidenz", info: .info(text: model.formattedSevenDayIncidence))]
    }

    private func makeSecondRowInfos() -> [RowInfo] {
        return [RowInfo(title: "Verstorben", info: .info(text: "\(model.deaths)")),
                RowInfo(title: "Genesen", info: .info(text: "\(model.healthy)")),
                RowInfo(title: "Verstorben ges.", info: .info(text: "\(model.totalDeaths)"))]
    }

    private func makeThirdRowInfos() -> [RowInfo] {
        return [RowInfo(title: "Normal Frei", info: .info(text: model.normalBedString)),
                RowInfo(title: "Intensiv Frei", info: .info(text: model.icuBedString)),
                RowInfo(title: "Trend ICU", info: .trend(trend: model.icuTrend))]
    }
}

struct OverviewItem_Previews: PreviewProvider {
    static var previews: some View {
        OverviewItemView(model: .stub(), didTap: { _ in })
    }
}

// MARK: Helper Views

private struct RowInfo: Identifiable {
    let id = UUID()
    let title: String
    let info: RowInfoTextType
}

private struct HorizontalInfoView: View {
    let infos: [RowInfo]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<infos.count) { index  in
                VerticalInfoView(info: infos[index])
                if index != infos.count - 1 {
                    SeparatorView()
                }
            }
            Spacer()
        }
    }
}

private struct VerticalInfoView: View {
    let info: RowInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(info.title)
                .font(.body)
                .foregroundColor(.white)
            switch info.info {
            case let .trend(trend):
                makeText(for: trend)
            case let .info(text):
                Text(text)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
        }
    }

    func makeText(for trend: Trend) -> Text {
        switch trend {
        case let .high(precentage):
            return Text("+ \(String(format: "%.1f", precentage))%")
                .font(.title3)
                .bold()
                .foregroundColor(.red)
        case let .low(precentage):
            return Text("\(String(format: "%.1f", precentage))%")
                .font(.title3)
                .bold()
                .foregroundColor(.green)
        }
    }
}
