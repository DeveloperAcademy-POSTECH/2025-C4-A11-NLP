//
//  Untitled.swift
//  Diary
//
//  Created by Yurim on 7/25/25.
//

import SwiftUI

struct DateRangeConfig {
    static let minOffset = -5
    
    static var allowedYears: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current + minOffset)...current)
    }
}

struct MonthYearPickerPopup: View {
  @Binding var selectedYear: Int
  @Binding var selectedMonth: Int
  @Binding var isPresented: Bool
  var onConfirm: () -> Void

  let years = Array(2021...2025)
  let months = Array(1...12)

  var body: some View {
    ZStack {
      Color.black.opacity(0.2)
        .ignoresSafeArea()

      VStack(spacing: 16) {
        HStack(spacing: 0) {
          Picker("년", selection: $selectedYear) {
            ForEach(years, id: \.self) { year in
                Text(String(format: "%d년", year)).tag(year)
            }
          }
          .labelsHidden()
          .frame(width: 150)
          .clipped()

          Picker("월", selection: $selectedMonth) {
            ForEach(months, id: \.self) { month in
                Text(String(format: "%d월", month)).tag(month)
            }
          }
          .labelsHidden()
          .frame(width: 150)
          .clipped()
        }
        .pickerStyle(.wheel)
        .padding(.vertical)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        .frame(height: 184)

        Button(action: {
          isPresented = false
          onConfirm()
        }) {
          Text("확인")
            .bold()
            .frame(width: 80, height: 40)
            .background(Color("blue3"))
            .foregroundStyle(Color("black"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
      }
    }
  }
}

/*
 //파라미터 넣기
#Preview {
    MonthYearPickerPopup()
}
*/
