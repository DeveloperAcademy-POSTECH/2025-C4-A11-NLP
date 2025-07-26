//
//  InfoButton.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct InfoButton: View{
    
    @Binding var isInfoShown: Bool
    
    var body: some View {
        Button(action: {
          isInfoShown.toggle()
        }) {
          Image(systemName: "info.circle.fill")
            .font(.system(size: 24))
            .foregroundStyle(Color("gray1"))
            .padding()
        }
    }
}

struct InfoOverlay: View{
    var body: some View {
        VStack(alignment: .leading, spacing: 9.5) {
          HStack(spacing: 8) {
            Circle()
              .fill(Color("blue2"))
              .frame(width: 20, height: 20)
            Text("회고 없음")
              .font(.system(size: 14))
          }

          HStack(spacing: 8) {
            Circle()
              .fill(Color("blue1"))
              .frame(width: 20, height: 20)
            Text("회고 완료")
              .font(.system(size: 14))
          }
        }
        .frame(width: 84, height: 48)
        .padding()
        .background(Color("white"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
        .padding(.top, 68)
        .padding(.trailing, 16)
    }
}

#Preview {
    InfoButton(isInfoShown: .constant(true))
}
