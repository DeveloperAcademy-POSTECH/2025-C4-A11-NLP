//
//  SplashView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI


struct SplashView: View {
    var isAuthAvailable: Bool
    var authFailed: Bool
    var onRetry: () -> Void
    
    var body: some View {
        ZStack {
            Color("brown01")
                .ignoresSafeArea()
            VStack {
                Image("greenbook")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Image(systemName: "faceid")
                Text("앱 아이콘")
                
                // FaceID가 필요한 경우 안내문구와 버튼 표시
                if isAuthAvailable {
                    Text("일기를 쓰려면 Face ID를 사용하십시오.")
                        .foregroundStyle(.gray)
                    
                    if authFailed {
                        Button("Face ID/비밀번호 다시 시도") {
                            onRetry()
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView(
            isAuthAvailable: true,
            authFailed: false,
            onRetry: {
                print("다시 시도")
            }
        )
}
