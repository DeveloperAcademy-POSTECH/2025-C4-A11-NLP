//
//  WiseSayingContentView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/24/25.
//

import SwiftUI

struct WiseSayingContentButton: View {
    
    let content: String
    let respondent: String
    let source: String
    let isSelected: Bool 
    
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue3)
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.blue2, lineWidth: 5)
                    }
                }
                .overlay {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(content)
                            .font(isSelected ? Font.body2Emphasized : Font.body2Regular)
                            .foregroundStyle(Color.black)
                        
                        HStack(spacing: 4) {
                            Text(respondent)
                                .font(.system(size: 13)).bold()
                                .foregroundStyle(Color.black)
                            Text(source)
                                .font(Font.caption1Emphasized)
                                .foregroundStyle(Color.gray01)
                        }
                    }
                }
        }
    }
}

#Preview {
    VStack {
        WiseSayingContentButton(
            content: "하루하루는 성실하게. 인생 전체는 되는대로.",
            respondent: "Libby",
            source: "(이동진)",
            isSelected: true
        ) {}
        WiseSayingContentButton(
            content: "꾸준함이 힘이다.",
            respondent: "Kim",
            source: "(작자미상)",
            isSelected: false
        ) {}
    }
}
