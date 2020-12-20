//
//  GeneralContentViewItem.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 29.08.20.
//

import SwiftUI

struct GeneralContentViewItem: View {
    let info: GeneralViewViewModel.Info
    let didTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.secondary)
                .padding(.horizontal)

            HStack(spacing: 8) {
                Image(uiImage: info.icon)
                .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .padding(EdgeInsets(top: 24, leading: 32, bottom: 24, trailing: 0))
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(info.title)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    HStack(spacing: 4) {
                        Text(info.subTitle)
                            .font(.body)
                            .foregroundColor(.white)
                        if let increase = info.increase {
                            Text("+\(increase)")
                                .font(.body)
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                }
                Spacer()
            }
        }
        .onTapGesture {
            didTap()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct GeneralContentViewItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeneralContentViewItem(info:
                                    GeneralViewViewModel.Info(icon: UIImage(systemName: "heart.fill")!,
                                                              title: "Active Cases", subTitle: "2876",
                                                              increase: 10,
                                                              type: .availableIntensiveCareBeds),
                                   didTap: {})
            GeneralContentViewItem(info:
                                    GeneralViewViewModel.Info(icon: UIImage(systemName: "heart.fill")!,
                                                              title: "Active Cases", subTitle: "2876",
                                                              increase: nil,
                                                              type: .availableIntensiveCareBeds),
                                   didTap: {})
        }

    }
}
