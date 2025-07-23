//
//  CalendarView.swift
//  Diary
//
//  Created by Yurim on 7/24/25.
//

import SwiftUI

struct CalendarView: View {
  @Binding var month: Date
  @Binding private var clickedCurrentMonthDates: Date?
  @Binding private var isMonthPickerPresented : Bool
  @State private var selectedYear = Calendar.current.component(.year, from: Date())
  @State private var selectedMonth = Calendar.current.component(.month, from: Date())
  @ObservedObject var diaryStore: DiaryStore


    init(
        month: Binding<Date>,
        clickedCurrentMonthDates: Binding<Date?>,
        isMonthPickerPresented: Binding<Bool>,
        diaryStore: DiaryStore
      ) {
        _month = month
        _clickedCurrentMonthDates = clickedCurrentMonthDates
        _isMonthPickerPresented = isMonthPickerPresented
        self.diaryStore = diaryStore
      }
  
    var body: some View {
      VStack(spacing: 0) {
        yearMonthView

        VStack(spacing: 0) {
          weekdayView
            .padding(.vertical, 10)

          calendarGridView
            .padding(.top, 4)
        }
        .padding()
        .background(Color(red: 247/255, green: 248/255, blue: 250/255))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
      }
    }
    
    // MARK: - 요일 표시
    private var weekdayView: some View {
      HStack {
        ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
          Text(Self.weekdaySymbols[symbol])
            .font(.system(size: 13))
            .bold()
            .foregroundStyle(Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
            .frame(maxWidth: .infinity)
        }
      }
    }

  
  // MARK: - 연월 표시
  private var yearMonthView: some View {
      
    HStack(alignment: .center, spacing: 8) {
      Text(month, formatter: Self.calendarHeaderDateFormatter)
            .font(.system(size: 17))
            .bold()
            .foregroundStyle(Color(red: 26/255, green: 26/255, blue: 26/255))
        
        Button(
          action: {
              isMonthPickerPresented = true
          },
          label: {
            Image(systemName: "chevron.right")
                  .font(.system(size: 17))
                  .bold()
                  .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 255/255))

          }
        )
        
        Spacer()
        
        Button(
          action: {
            changeMonth(by: -1)
          },
          label: {
            Image(systemName: "chevron.left")
                  .font(.system(size: 20))
                  .bold()
                  .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 255/255))
          }
        )
        
        Spacer().frame(width: 28)
      
      Button(
        action: {
          changeMonth(by: 1)
        },
        label: {
          Image(systemName: "chevron.right")
                .font(.system(size: 20))
                .bold()
                .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 255/255))

        }
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 9)

  }


  
  // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
      let daysInMonth = numberOfDays(in: month)
      let firstWeekday = firstWeekdayOfMonth(in: month) - 1
      let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
      let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
      let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)

      return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 3) {
        ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
          calendarCellView(for: index, daysInMonth: daysInMonth, firstWeekday: firstWeekday, lastDayOfMonthBefore: lastDayOfMonthBefore)
        }
      }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
  private var day: Int
  private var clicked: Bool
  private var isToday: Bool
  private var isCurrentMonthDay: Bool
  let reflectionStatus: ReflectionStatus
    
    private var textColor: Color {
      if isToday {
        return Color(red: 23 / 255, green: 76 / 255, blue: 192 / 255)
      } else if isCurrentMonthDay {
        return Color(red: 26/255, green: 26/255, blue: 26/255)
      } else {
        return Color(red: 202/255, green: 203/255, blue: 204/255)
      }
    }


  
  fileprivate init(
    day: Int,
    clicked: Bool = false,
    isToday: Bool = false,
    isCurrentMonthDay: Bool = true,
    reflectionStatus: ReflectionStatus = .none
  ) {
    self.day = day
    self.clicked = clicked
    self.isToday = isToday
    self.isCurrentMonthDay = isCurrentMonthDay
      self.reflectionStatus = reflectionStatus
  }
  
    
    fileprivate var body: some View {
      VStack {
        ZStack {
          // 회고 상태에 따른 색상 원
          switch reflectionStatus {
          case .pending:
            Circle()
              .fill(Color(red: 178/255, green: 203/255, blue: 255/255))
              .frame(width: 36, height: 36)
          case .completed:
            Circle()
              .fill(Color(red: 102/255, green: 150/255, blue: 255/255))
              .frame(width: 36, height: 36)
          case .none:
            EmptyView()
          }

          // 오늘이면 원 테두리
          if isToday {
            Circle()
              .stroke(Color(red: 23/255, green: 76/255, blue: 192/255), lineWidth: 3)
              .frame(width: 36, height: 36)
          }

          // 날짜 숫자 텍스트
          Text(String(day))
            .foregroundStyle(textColor)
            .font(.system(size: 20))
            .bold()
        }
      }
      .frame(height: 40)
    }
}

private extension CalendarView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    static let weekdaySymbols: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar.shortWeekdaySymbols
    }()
}

private extension CalendarView {
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
    private func calendarCellView(for index: Int, daysInMonth: Int, firstWeekday: Int, lastDayOfMonthBefore: Int) -> some View {
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
