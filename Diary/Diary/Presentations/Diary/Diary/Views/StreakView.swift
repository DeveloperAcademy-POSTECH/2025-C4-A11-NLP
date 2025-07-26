//
//  StreakView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import SwiftUI

struct StrokeText: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let fontName: String?
    let strokeColor: UIColor
    let textColor: UIColor
    let strokeWidth: CGFloat

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = attributedString
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
    }
    
    var attributedString: NSAttributedString {
        let font: UIFont
        if let fontName = fontName, let customFont = UIFont(name: fontName, size: fontSize) {
            font = customFont
        } else {
            font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .strokeColor: strokeColor,
            .strokeWidth: -strokeWidth,
            .font: font
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

struct StreakView: View {
    let lottieType: LottieType
    
    let customGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(hex: "#E1E9FA").opacity(1.0), location: 0.0),
            .init(color: Color(hex: "#007AFF").opacity(0.5), location: 0.49),
            .init(color: Color(hex: "#E1E9FA").opacity(1.0), location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            
            customGradient.ignoresSafeArea()
            
            VStack(spacing: .zero) {
                LottieView(name: lottieType.lottie)
                    .frame(width: 137, height: 165)
                
                Spacer().frame(height: 100) //FIXME: 임시
                
                StrokeText(
                    text: "0",
                    fontSize: 48,
                    fontName: "SFProRounded-Black",
                    strokeColor: UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0),
                    textColor: .white,
                    strokeWidth: 6
                )
                .frame(width: 60, height: 60)
            }
        }
    }
}

#Preview {
    StreakView(lottieType: .fire)
}
