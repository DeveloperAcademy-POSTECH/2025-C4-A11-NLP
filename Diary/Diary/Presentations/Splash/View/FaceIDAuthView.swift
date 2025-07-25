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
    @State private var isAuthAvailable = false
    
    var body: some View {
        ZStack {
            //SplashView
            if isAuthAvailable {
                // 암호 있을 때
                VStack(spacing: 20) {
                    Image(systemName: "faceid")
                    Text("앱 아이콘")
                    Text("일기를 쓰려면 Face ID를 사용하십시오.")
                        .foregroundStyle(.gray)
                        
                    //인증 실패 시 재인증을 위한 버튼
                    if authFailed {
                        Button("Face ID/비밀번호 다시 시도") {
                            authenticate()
                        }
                        .padding()
                    }
                }
            } else {
                // 암호 없을 때
                VStack(spacing: 20) {
                    Image(systemName: "faceid")
                    Text("앱 아이콘")
                }
            }
        }
        .onAppear {
            checkAuthAvailability()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                authenticate()
            }
        }
    }
    
    // FaceID/비밀번호 유무 확인
    func checkAuthAvailability() {
        let context = LAContext()
        var error: NSError?
        
        isAuthAvailable = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    // FaceID/비밀번호 인증 시도
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Face ID 또는 비밀번호로 인증해주세요"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                    } else {
                        authFailed = true
                    }
                }
            }
        } else {
            // Face ID 지원 X -> 자동 인증
            isAuthenticated = true
        }
    }
}
