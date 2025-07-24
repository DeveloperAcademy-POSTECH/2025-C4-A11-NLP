//
//  CalenderContentButton.swift
//  Diary
//
//  Created by jinhyeokKim on 7/23/25.
//

import SwiftUI

struct CalenderContentButton: View {
    
    let title: String
    let imageType: CalenderContentButtonType
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue3)
                .overlay {
                    switch imageType {
                    case .previous:
                        HStack(spacing: 8) {
                            Group {
                                Image(systemName: imageType.image)
                                Text(title)
                            }
                            .foregroundStyle(Color.black)
                            .font(Font.caption1Emphasized)
                        }
                    case .next:
                        HStack(spacing: 8) {
                            Group {
                                Text(title)
                                Image(systemName: imageType.image)
                            }
                            .foregroundStyle(Color.black)
                            .font(Font.caption1Emphasized)
                        }
                    }
                }
        }
    }
}

#Preview {
    CalenderContentButton(title: "이전", imageType: .previous) {
        print("이전")
    }
    CalenderContentButton(title: "다음", imageType: .next) {
        print("다음")
    }
}
