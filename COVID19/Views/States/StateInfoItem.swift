//
//  StateInfoItem.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 05.09.20.
//

import SwiftUI

struct StateInfoItem: View {
    let stateInfo: StateInfo
    let formattedDate: String
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(UIColor.systemGray2))
                .shadow(radius: 10)
                .padding(.horizontal)
            HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(stateInfo.name.uppercased()).font(.title)
                        .fontWeight(.bold)
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Active Cases")
                            Text("\(stateInfo.activeCases)")
                                .foregroundColor(.primary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("GKZ")
                            Text("\(stateInfo.gkz)")
                                .foregroundColor(.primary)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Update at")
                            Text(formattedDate)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 0))
                Spacer()
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct StateInfoItem_Previews: PreviewProvider {
    static var previews: some View {
        StateInfoItem(stateInfo: .stub(), formattedDate: "Today")
    }
}
