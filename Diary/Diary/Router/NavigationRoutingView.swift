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
                InputDiaryView(viewType: .new, date: date)
            case .inputDiaryUpdateView(let date, let viewType):
                InputDiaryView(viewType: viewType, date: date)
            case .resolutionView:
                ResolutionView(viewType: .new)
            case .resolutionUpdateView:
                ResolutionView(viewType: .update)
            case .retrospectiveView:
                RetrospectiveView()
            case .wiseSayingView:
                WiseSayingView(viewType: .new)
            case .wiseSayingUpdateView:
                WiseSayingView(viewType: .update)
            case .streakView:
                StreakView(lottieType: .fire)
            }
        }
        .hideBackButton()
        .modelContainer(for: [DiaryModelData.self])
        .environmentObject(router)
    }
}

