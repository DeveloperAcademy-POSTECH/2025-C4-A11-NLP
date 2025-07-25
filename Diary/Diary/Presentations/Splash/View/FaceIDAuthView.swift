//
//  FaceIDAuthView.swift
//  Diary
//
//  Created by JiJooMaeng on 7/24/25.
//

import SwiftUI
import LocalAuthentication

struct FaceIDAuthView: View {
    @Binding var isAuthenticated: Bool
    @StateObject private var viewModel = FaceIDAuthViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isAuthAvailable {
                VStack(spacing: 20) {
                    Image(systemName: "faceid")
                    Text("앱 아이콘")
                    Text("일기를 쓰려면 Face ID를 사용하십시오.")
                        .foregroundStyle(.gray)
                        
                    if viewModel.authFailed {
                        Button("Face ID/비밀번호 다시 시도") {
                            viewModel.authenticate()
                        }
                        .padding()
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "faceid")
                    Text("앱 아이콘")
                }
            }
        }
        .onAppear {
            viewModel.checkAuthAvailability()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.authenticate()
            }
        }
        .onChange(of: viewModel.isAuthenticated) { _, newValue in
            isAuthenticated = newValue
        }
    }
}
