//
//  StreakView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import SwiftUI

struct StreakView: View {
    let lottieType: LottieType
    
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var lottieManager: LottieManager
    
    @State var test: Int = 0
    @State private var colorChange: Bool = false
    @State private var showResult = false
    @State private var showResult2 = false
    @State private var remove = false
    @State private var showConfettie = false
    
    let customGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(hex: "#FFFFFF"), location: 0.0),
            .init(color: Color(hex: "#FFE993").opacity(0.6), location: 0.5),
            .init(color: Color(hex: "#FFFFFF"), location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            
            if colorChange {
                customGradient.ignoresSafeArea()
            } else {
                Color.white.ignoresSafeArea()
            }
            
            
            // Lottie 애니메이션 (shouldPlayLottie가 true일 때만)
            if showConfettie {
                LottieView(name: "confettie")
                    .frame(width: 200, height: 200)
                    .onAppear { //FIXME: 코드 수정
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//                            lottieManager.shouldPlayLottie = false
                        }
                    }
                    .transition(.opacity)
            }
            
            
            VStack(spacing: .zero) {
                LottieView(name: lottieType.lottie)
                    .frame(width: 137, height: 165)
                    .scaleEffect(showResult ? 0.5 : 1)

                
                Spacer().frame(height: 80) //FIXME: 임시
                
                Text("\(test)")
                    .font(.system(size: 40))
                    .foregroundStyle(colorChange ? Color.red01 : Color.gray03)
                    .opacity(remove ? 0 : 1)
                
                //FIXME: 텍스트 위치 임의 조정
                VStack(alignment: .center) {
                    HStack {
                        Text("\(test)")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.red01)
                            .opacity(showResult ? 1 : 0)
                            .offset(y: showResult ? -140 : 0)
                        
                        
                        Text("번째 기록 완료!")
                            .font(.system(size: 24)).bold()
                            .foregroundColor(Color.black01)
                            .opacity(showResult ? 1 : 0)
                            .offset(y: showResult ? -140 : 0)
                    }
                    
                    Text("기록하는 습관, 다짐하는 마음.\n이미 성장하고 있어요!")
                        .font(.system(size: 24)).bold()
                        .foregroundColor(Color.black01)
                        .opacity(showResult2 ? 1 : 0)
                        .offset(y: showResult2 ? -140 : 0)
                        .multilineTextAlignment(.center)
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    test += 1
                    colorChange = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    remove = true
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showConfettie = true
                        showResult = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showResult2 = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showConfettie = false
                                    lottieManager.shouldPlayLottie = true
                                    router.popToRootView()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StreakView(lottieType: .fire)
        .environmentObject(NavigationRouter())
}
