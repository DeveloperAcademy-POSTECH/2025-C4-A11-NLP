//
//  DiaryApp.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import SwiftUI
import SwiftData

@main
struct DiaryApp: App {
    @StateObject var router: NavigationRouter = .init()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .modelContainer(for: DiaryModelData.self)
        }
    }
}

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if isAuthenticated {
                HomeView()
            } else {
                FaceIDAuthView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
