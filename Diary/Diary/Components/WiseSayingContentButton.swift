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
    
    @State private var selectedContent: String? = nil
    
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
                        HStack {
                            Text(content)
                                .font(isSelected ? Font.body1Semibold : Font.body1Regular)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.leading) 
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                            Spacer()
                        }
                        .padding(.top, 24)
                        
                        HStack(spacing: 4) {
                            Text(respondent)
                                .font(.system(size: 13)).bold()
                                .foregroundStyle(Color.black)
                            Text(source)
                                .font(Font.caption2Emphasized)
                                .foregroundStyle(Color.gray01)
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 24)
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
            .frame(height: 110)
        WiseSayingContentButton(
            content: "꾸준함이 힘이다.",
            respondent: "Kim",
            source: "(작자미상)",
            isSelected: false
        ) {}
    }
    .padding(.horizontal, 16)
}
