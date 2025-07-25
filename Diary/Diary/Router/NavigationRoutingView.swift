//
//  NavigationRoutingView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/23/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject var router: NavigationRouter
    
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .home:
                HomeView()
            }
        }
        .environmentObject(router)
    }
}

