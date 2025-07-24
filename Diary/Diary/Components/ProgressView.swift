//
//  ProgressView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/24/25.
//

import SwiftUI

struct ProgressView: View {
    let choice: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(choice ? Color.blue01 : Color.gray1)
    }
}

#Preview() {
    Group {
        ProgressView(choice: true)
        
        Spacer().frame(height: 40)
        
        ProgressView(choice: false)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 4)
    .padding(.horizontal, 16)
}
