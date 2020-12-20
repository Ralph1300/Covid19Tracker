//
//  GeneralView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import SwiftUI

struct GeneralView: View {

    @ObservedObject var viewModel: GeneralViewViewModel

    @State var showsPositivesChart = false

    init(viewModel: GeneralViewViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded, .error:
                    if let commonInfo = viewModel.commonInfo {
                        GeneralListView(commonInfo: commonInfo,
                                        infos: viewModel.infos,
                                        formattedDate: viewModel.formattedDate, didTapInfo: { info in
                                            self.handleTap(on: info)
                                        })
                    } else {
                        Text("No info available, sorry.")
                    }
                }
            }
            .sheet(isPresented: $showsPositivesChart) {
                BarChartView(entries: viewModel.entries,
                             title: "Positives",
                             infoText: "This graph shows the last 20 days and the new infections on those days.",
                             isPresented: $showsPositivesChart)
            }
            .navigationTitle("Heute")
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.reload()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle.fill").imageScale(.large)
                        .foregroundColor(.primary)
                }
            )
        }
        .onAppear {
            viewModel.load()
        }
    }

    private func handleTap(on info: GeneralViewViewModel.Info) {
        switch info.type {
        case .positives:
            break
//            self.showsPositivesChart = true
        default:
            break
        }
    }
}

private struct GeneralListView: View {
    let commonInfo: CommonInfo
    let infos: [GeneralViewViewModel.Info]
    let formattedDate: String

    let didTapInfo: (GeneralViewViewModel.Info) -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8, content: {
                    ForEach(infos) { info in
                        GeneralContentViewItem(info: info) {
                            didTapInfo(info)
                        }
                    }
                })
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeneralView(viewModel: GeneralViewViewModel(remote: .shared, commonInfo: .stub()))

            GeneralView(viewModel: GeneralViewViewModel(remote: .shared, commonInfo: .stub()))
                .environment(\.colorScheme, .dark)
        }
    }
}
