//
//  BarChart.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 20.09.20.
//

import SwiftUI

struct BarChartEntry: Identifiable {
    let id = UUID()
    let value: Int
    let footnote: String

    var height: CGFloat {
        return CGFloat(value)
    }
}

struct BarChartView: View {
    let entries: [BarChartEntry]
    let title: String
    let infoText: String

    var isPresented: Binding<Bool>

    var body: some View {
        NavigationView {
            BarChart(entries: entries)
                .navigationTitle(title)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.isPresented.wrappedValue = false
                                        }) {
                                            Image(systemName: "multiply").imageScale(.large)
                                                .foregroundColor(.primary)
                                        })
        }
    }
}

struct BarChart: View {

    let entries: [BarChartEntry]

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(entries) { entry in
                    VStack {
                        Spacer()
                        Bar(color: .green,
                            height: entry.height)
                        Text(entry.footnote)
                            .font(.footnote)
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
    }
}

struct Bar: View {
    let color: Color
    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 15, height: height * 0.5)
    }
}

struct BarChart_Previews: PreviewProvider {
    static var allEntries: [BarChartEntry] {
        return (0...50).map { _ in BarChartEntry(value: 25, footnote: "Test") }
    }
    static var previews: some View {
        BarChart(entries: [
            BarChartEntry(value: 20, footnote: "Test"),
            BarChartEntry(value: 50, footnote: "Test"),
            BarChartEntry(value: 35, footnote: "Test"),
            BarChartEntry(value: 25, footnote: "Test")
        ])
        BarChart(entries: allEntries)
    }
}
