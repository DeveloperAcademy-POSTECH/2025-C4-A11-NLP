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
            .foregroundStyle(Color(red: 222/255, green: 223/255, blue: 224/255))
            .padding()
        }
    }
}

struct InfoOverlay: View{
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 8) {
            Circle()
              .fill(Color(red: 178/255, green: 203/255, blue: 255/255))
              .frame(width: 30, height: 30)
            Text("회고 없음")
              .font(.system(size: 24))
          }

          HStack(spacing: 8) {
            Circle()
              .fill(Color(red: 77/255, green: 133/255, blue: 255/255))
              .frame(width: 30, height: 30)
            Text("회고 완료")
              .font(.system(size: 24))
          }
        }
        .frame(width: 189, height: 70)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 0)
        .padding(.top, 50)
        .padding(.trailing, 16)
        .zIndex(1)
    }
}

#Preview {
    InfoButton(isInfoShown: .constant(true))
}
