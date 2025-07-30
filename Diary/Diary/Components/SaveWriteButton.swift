//
//  SaveWriteButton.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import SwiftUI

struct SaveWriteButton: View {
    let title: String
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green6)
                .overlay {
                    Text(title)
                        .font(Font.caption1)
                        .foregroundStyle(Color.white)
                }
        }
    }
}

#Preview() {
    SaveWriteButton(title: "저장하기") {
        print("저장하기")
    }
    .frame(width: 100, height: 44)
    
    SaveWriteButton(title: "회고하기") {
        print("회고하기")
    }
    .frame(width: 100, height: 44)
}
