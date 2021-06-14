//
//  GeneralView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import SwiftUI

struct GeneralView: View {

    @ObservedObject var viewModel: GeneralViewViewModel

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
                    if let commonInfo = viewModel.timeline {
                        GeneralListView(commonInfo: commonInfo,
                                        infos: viewModel.infos,
                                        formattedDate: viewModel.formattedDate, didTapInfo: { _ in
                                        })
                    } else {
                        Text("No info available, sorry.")
                    }
                }
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
}

private struct GeneralListView: View {
    let commonInfo: TimelineStates
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
            GeneralView(viewModel: GeneralViewViewModel(remote: .shared, timeline: .stub()))

            GeneralView(viewModel: GeneralViewViewModel(remote: .shared, timeline: .stub()))
                .environment(\.colorScheme, .dark)
        }
    }
}
