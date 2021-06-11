//
//  StateView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import SwiftUI

struct StateView: View {
    
    @ObservedObject var viewModel: StateViewModel
    @State var showsDetails = false

    @State var selectedModel: OverviewItemModel?

    init(viewModel: StateViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.timelineInfos.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.timelineInfos) { model in
                                OverviewItemView(model: model) { tappedModel in
                                    self.selectedModel = tappedModel
                                    showsDetails = true
                                }
                            }
                            Color.clear
                        }
                    }
                }
            }
            .navigationTitle("Bundesländer")
        }
        .background(Color.primary)
        .onAppear {
            viewModel.load()
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView()
    }
}
