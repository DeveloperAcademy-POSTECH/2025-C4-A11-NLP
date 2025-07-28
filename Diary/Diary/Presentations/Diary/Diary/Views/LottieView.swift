//
//  LottieView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String          // Lottie 파일 이름
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        //animationView.loopMode = loopMode
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        
    }
}

#Preview {
    LottieView(name: "confettie")
        .frame(width: 200, height: 200)
    
    Spacer()
    
    LottieView(name: "fire")
        .frame(width: 200, height: 200)
    
    Spacer()
    
    LottieView(name: "loading")
        .frame(width: 200, height: 200)
}
