//
//  WriteReflectionButton.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct WriteReflectionButton: View{
    var body: some View {
        Button(action: {
            // 회고 작성 화면으로 이동
        }) {
            Text("회고 쓰기")
                .bold()
                .font(.system(size: 14))
                .foregroundStyle(Color("white"))
                .frame(width: 104, height: 44)
                .background(Color("blue1"))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 13.5)
                .padding(.trailing, 24)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 16)
    }
}

#Preview {
    WriteReflectionButton()
}
