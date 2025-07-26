//
//  AddEntryButton.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct AddEntryButton: View{
    let action: () -> ()
    
    var body: some View {
        Button(action: {
          action()
        }) {
          Image(systemName: "plus")
            .bold()
            .font(.system(size: 32))
            .foregroundStyle(.white)
            .frame(width: 59, height: 59)
            .background(Color(red: 36/255, green: 36/255, blue: 205/255))
            .clipShape(Circle())
            .shadow(radius: 4)
            .padding(.bottom, 30)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    AddEntryButton() {
        
    }
}
