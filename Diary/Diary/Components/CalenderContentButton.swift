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
    @Environment(\.isEnabled) private var isEnabled: Bool
    
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
                            .foregroundStyle(isEnabled ? Color.black : Color.gray02)
                            .font(Font.caption1Emphasized)
                        }
                    case .next:
                        HStack(spacing: 8) {
                            Group {
                                Text(title)
                                Image(systemName: imageType.image)
                            }
                            .foregroundStyle(isEnabled ? Color.black : Color.gray02)
                            .font(Font.caption1Emphasized)
                        }
                    case .none:
                        HStack(spacing: 8) {
                            Group {
                                Text(title)
                            }
                            .foregroundStyle(isEnabled ? Color.black : Color.gray02)
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
    CalenderContentButton(title: "완료", imageType: .none) {
        print("다음")
    }
}
