//
//  AddEntryButton.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct AddEntryButton: View {
    var body: some View {
        NavigationLink(destination: InputDiaryView()) {
            Image(systemName: "plus")
                .bold()
                .font(.system(size: 32))
                .foregroundStyle(Color("white"))
                .frame(width: 59, height: 59)
                .background(Color("blue1"))
                .clipShape(Circle())
                .shadow(radius: 4)
                .padding(.bottom, 30)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    AddEntryButton()
}
