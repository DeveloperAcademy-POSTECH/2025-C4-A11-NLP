//
//  date+.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation

extension Date {
  var formattedWithWeekday: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
    return formatter.string(from: self)
  }
}
