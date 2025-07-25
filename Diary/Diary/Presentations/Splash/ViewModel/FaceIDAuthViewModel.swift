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
    
    func checkAuthAvailability() {
        let context = LAContext()
        var error: NSError?
        
        isAuthAvailable = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
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
            self.isAuthenticated = true
        }
    }
}
