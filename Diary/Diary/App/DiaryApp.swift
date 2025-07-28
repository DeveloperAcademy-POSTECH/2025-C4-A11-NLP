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
            HomeView()
                .modelContainer(for: DiaryModelData.self)
                .environmentObject(router)
        }
    }
}
