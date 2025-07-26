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
            case .inputDiaryView:
                InputDiaryView()
                    .hideBackButton()
            case .resolutionView:
                ResolutionView(date: "2025년 07월 13일 (월)", text: "") //FIXME: 초기값 변경
                    .hideBackButton()
            case .retrospectiveView:
                RetrospectiveView(date: "2025년 07월 13일 (월)") //FIXME: 초기값 변경
                    .hideBackButton()
            case .wiseSayingView:
                WiseSayingView(date: "2025년 07월 13일 (월)") //FIXME: 초기값 변경
                    .hideBackButton()
            case .streakView:
                StreakView(lottieType: .fire)
                    .hideBackButton()
            }
        }
        .environmentObject(router)
    }
}

