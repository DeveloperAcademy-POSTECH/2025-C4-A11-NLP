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
                Spacer()
                VStack(spacing: 40) {
                    VStack(spacing: 0) {
                        Image("applogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                        Text("Quotiary")
                            .font(Font.ppAcma50)
                            .foregroundStyle(Color.white)
                    }

                    if isAuthAvailable && authFailed {
                        Button(action: {
                            onRetry()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "faceid")
                                Text("Face ID 또는")
                                Image(systemName: "lock.fill")
                                Text("비밀번호로 다시 시도")
                            }
                            .font(.caption3)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 15)
                            .background(Color(.black))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SplashView(
        isAuthAvailable: true,
        authFailed: true,
        onRetry: {
            print("다시 시도")
        }
    )
}
