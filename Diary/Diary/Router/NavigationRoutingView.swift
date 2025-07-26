//
//  NavigationRoutingView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/23/25.
//

import SwiftUI
import SwiftData

struct NavigationRoutingView: View {
    
    @EnvironmentObject var router: NavigationRouter
    
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .home:
                HomeView()
            case .inputDiaryView(let date):
                InputDiaryView(date: date)
            case .resolutionView:
                ResolutionView(text: "") //FIXME: 초기값 변경
            case .retrospectiveView:
                RetrospectiveView()
            case .wiseSayingView:
                WiseSayingView()
            case .streakView:
                StreakView(lottieType: .fire)
            }
        }
        .hideBackButton()
        .modelContainer(for: [DiaryModelData.self])
        .environmentObject(router)
    }
}

