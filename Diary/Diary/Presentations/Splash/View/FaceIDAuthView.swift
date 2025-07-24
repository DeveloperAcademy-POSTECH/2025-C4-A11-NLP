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
    @State private var authFailed = false

    var body: some View {
        ZStack {
            //SplashView
            VStack(spacing: 20) {
                Image(systemName: "faceid")
                    .resizable()
                    .frame(width: 60, height: 60)

                Text("일기를 쓰려면 Face ID를 사용하십시오.")
                    .foregroundStyle(.gray)

                if authFailed {
                    Button("Face ID 다시 시도") {
                        authenticate()
                    }
                    .padding()
                    .cornerRadius(8)
                }

                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                authenticate()
            }
        }
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Face ID로 인증해주세요"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                    } else {
                        authFailed = true
                    }
                }
            }
        } else {
            // Face ID 지원 안됨 (기기 제한, 설정 미완 등)
            authFailed = true
        }
    }
}
