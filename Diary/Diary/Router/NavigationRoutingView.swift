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
                    .hideBackButton()
            case .inputDiaryView(let date):
                InputDiaryView(date: date)
                    .hideBackButton()
            case .resolutionView:
                ResolutionView(text: "") //FIXME: 초기값 변경
                    .hideBackButton()
            case .retrospectiveView:
                RetrospectiveView()
                    .hideBackButton()
            case .wiseSayingView:
                WiseSayingView()
                    .hideBackButton()
            case .streakView:
                StreakView(lottieType: .fire)
                    .hideBackButton()
            }
        }
        .environmentObject(router)
    }
}

