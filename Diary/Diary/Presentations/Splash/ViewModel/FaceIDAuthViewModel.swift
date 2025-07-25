//
//  FaceIDAuthViewModel.swift
//  Diary
//
//  Created by JiJooMaeng on 7/25/25.
//

import SwiftUI
import Combine
import LocalAuthentication

class FaceIDAuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var authFailed: Bool = false
    @Published var isAuthAvailable: Bool = false
    
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
                        self.isAuthenticated = true
                    } else {
                        self.authFailed = true
                    }
                }
            }
        } else {
            // Face ID 지원 X -> 자동 인증
            self.isAuthenticated = true
        }
    }
}
