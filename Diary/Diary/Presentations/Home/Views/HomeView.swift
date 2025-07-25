//
//  SwiftUIView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.destination) {
            Button {
                //:FIXME: 생성 버튼 기능으로 수정하기
            } label: {
                Text("Go Test1")
            }
            .navigationDestination(for: NavigationDestination.self, destination: { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(router)
            })
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
