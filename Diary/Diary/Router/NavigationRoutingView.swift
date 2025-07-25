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
            case .inputDiaryView:
                InputDiaryView()
            case .resolutionView:
                ResolutionView(date: "", text: "") //FIXME: 초기값 변경
            case .retrospectiveView:
                RetrospectiveView()
            case .wiseSayingView:
                WiseSayingView(date: "") //FIXME: 초기값 변경
            }
        }
        .environmentObject(router)
    }
}

