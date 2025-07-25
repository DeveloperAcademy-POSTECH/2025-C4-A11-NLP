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
                .foregroundStyle(Color(red: 23/255, green: 76/255, blue: 192/255))
                .frame(width: 80, height: 40)
                .background(Color(red: 225/255, green: 233/255, blue: 250/255))
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
