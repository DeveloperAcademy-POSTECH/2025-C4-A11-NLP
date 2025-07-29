//
//  WriteReflectionButton.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct WriteReflectionButton: View {
    let action: () -> ()
    var body: some View {
        Button(action: {
            // 회고 작성 화면으로 이동
            action()
        }) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue1)
                .overlay {
                    Text("회고 쓰기")
                        .font(Font.caption1)
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 14.5)
                }
        }
    }
}

#Preview {
    VStack {
        WriteReflectionButton() {
            print("회고 작성 화면으로 이동")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
    }
    .padding(.horizontal, 16)
}
