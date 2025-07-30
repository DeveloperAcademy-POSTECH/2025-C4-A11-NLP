//
//  DiaryDetailView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//
import SwiftUI

struct DiaryDetailView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.lightBlu76e.ignoresSafeArea()
            VStack {
                Text("자세히 보기 디테일")
            }
            .navigationTitle("날짜임시")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                        .font(.system(size: 23, weight: .semibold))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.blue)
                        .font(.system(size: 23, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DiaryDetailView()
            .environmentObject(NavigationRouter())
    }
}
