//
//  date+.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftUI

//캘린더 6줄로 만듥

extension Date {
  var formattedWithWeekday: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
    return formatter.string(from: self)
  }
}

extension CalendarView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }

    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()

    static let weekdaySymbols: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.shortWeekdaySymbols
    }()
}

extension CalendarView {
  /// 특정 해당 날짜
  func getDate(for index: Int) -> Date {
    let calendar = Calendar.current
    guard let firstDayOfMonth = calendar.date(
      from: DateComponents(
        year: calendar.component(.year, from: month),
        month: calendar.component(.month, from: month),
        day: 1
      )
    ) else {
      return Date()
    }

    var dateComponents = DateComponents()
    dateComponents.day = index

    let timeZone = TimeZone.current
    let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
    dateComponents.second = Int(offset)

    let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    return date
  }

  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }

  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!

    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }

  /// 이전 월 마지막 일자
  func previousMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: month)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!

    return previousMonth
  }

  /// 월 변경
  func changeMonth(by value: Int) {
    self.month = adjustedMonth(by: value)
  }

  /// 변경하려는 월 반환
  func adjustedMonth(by value: Int) -> Date {
    if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
      return newMonth
    }
    return month
  }
}


extension Date {
  static let calendarDayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter
  }()

  var formattedCalendarDayDate: String {
    return Date.calendarDayDateFormatter.string(from: self)
  }
}

extension CalendarView {
    @ViewBuilder
    func calendarCellView(for index: Int, daysInMonth: Int, firstWeekday: Int, lastDayOfMonthBefore: Int) -> some View {
        if index >= 0 && index < daysInMonth {
            let date = getDate(for: index)
            let day = Calendar.current.component(.day, from: date)
            let clicked = clickedCurrentMonthDates == date
            let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate

            let entry = diaryStore.diary(for: date)
            let status: ReflectionStatus = {
                if let entry = entry {
                    return entry.reflection == "-" ? .pending : .completed
                } else {
                    return .none
                }
            }()

            CellView(day: day, clicked: clicked, isToday: isToday, reflectionStatus: status)
                .onTapGesture {
                    clickedCurrentMonthDates = date
                }

        } else if let prevMonthDate = Calendar.current.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
        ) {
            let day = Calendar.current.component(.day, from: prevMonthDate)
            CellView(day: day, isCurrentMonthDay: false)
        }
    }
}
