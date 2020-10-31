//
//  StateView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import SwiftUI

struct StateView: View {
    
    @ObservedObject var viewModel: StateViewModel

    init(viewModel: StateViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.stateInfos.isEmpty {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.stateInfos) { info in
                                StateInfoItem(stateInfo: info,
                                              formattedDate: viewModel.formattedDate)
                            }
                            Color.clear
                        }
                    }
                }
            }
            .navigationTitle("State Information")
        }
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
