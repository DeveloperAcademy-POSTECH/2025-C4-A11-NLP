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
            SplashView(
                isAuthAvailable: viewModel.isAuthAvailable,
                authFailed: viewModel.authFailed,
                onRetry: {
                    viewModel.authenticate()
                }
            )
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

#Preview("Face ID 가능, 실패 안 함") {
    SplashView(
        isAuthAvailable: true,
        authFailed: false,
        onRetry: {
            print("다시 시도")
        }
    )
}
