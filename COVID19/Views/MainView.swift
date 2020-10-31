//
//  ContentView.swift
//  COVID19
//
//  Created by Ralph Schnalzenberger on 21.08.20.
//

import SwiftUI

struct MainView: View {
    enum Tab: Int {
        case general, stateInfo, world
    }

    @State var selectedTab: Tab = .general

    var body: some View {
        TabView {
            GeneralView()
                .tabItem {
                    Image(systemName: "heart.circle")
                    Text("General")
                }
            StateView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("States")
                }
            WorldView()
                .tabItem {
                    Image(systemName: "a.circle.fill")
                    Text("Global")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
