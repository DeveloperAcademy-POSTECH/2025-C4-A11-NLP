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
                .environmentObject(router)
                .modelContainer(for: [DiaryModelData.self])
        }
    }
}
