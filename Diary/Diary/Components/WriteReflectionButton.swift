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
                .font(.system(size: 13))
                .foregroundStyle(Color("white"))
                .frame(width: 80, height: 40)
                .background(Color("blue1"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 30)
                .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)
    }
}

#Preview {
    WriteReflectionButton()
}
