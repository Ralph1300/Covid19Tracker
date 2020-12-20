//
//  Separator.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 06.12.20.
//

import SwiftUI

struct SeparatorView: View {

    var body: some View {
        Rectangle()
            .foregroundColor(Color.white)
            .frame(width: 1)
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        SeparatorView()
    }
}
