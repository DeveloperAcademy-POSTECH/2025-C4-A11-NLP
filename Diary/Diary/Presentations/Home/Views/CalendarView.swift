//
//  CalendarView.swift
//  Diary
//
//  Created by Yurim on 7/24/25.
//

import SwiftUI

struct CalendarView: View {
    
  @Binding var month: Date
  @Binding var clickedCurrentMonthDates: Date?
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
        .background(Color("white"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
      }
    }


  // MARK: - 연월 표시
  private var yearMonthView: some View {

    HStack(alignment: .center, spacing: 8) {
      Text(month, formatter: Self.calendarHeaderDateFormatter)
            .font(.system(size: 17))
            .bold()
            .foregroundStyle(Color("black"))

        Button(
          action: {
              isMonthPickerPresented = true
          },
          label: {
            Image(systemName: "chevron.right")
                  .font(.system(size: 17))
                  .bold()
                  .foregroundStyle(Color("blue01"))

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
                  .foregroundStyle(Color("blue01"))
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
                .foregroundStyle(Color("blue01"))

        }
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 9)

  }

    // MARK: - 캘린더 요일
    private var weekdayView: some View {
      HStack {
        ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
          Text(Self.weekdaySymbols[symbol])
            .font(.system(size: 13))
            .bold()
            .foregroundStyle(Color("gray01"))
            .frame(maxWidth: .infinity)
        }
      }
    }


  // MARK: - 날짜 그리드
    private var calendarGridView: some View {
      let daysInMonth = numberOfDays(in: month)
      let firstWeekday = firstWeekdayOfMonth(in: month) - 1
      let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
      let numberOfRows = 6
      let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)

      return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 3) {
        ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
          calendarCellView(for: index, daysInMonth: daysInMonth, firstWeekday: firstWeekday, lastDayOfMonthBefore: lastDayOfMonthBefore)
        }
      }
    }
}



// MARK: - 날짜 숫자 셀
struct CellView: View {
  private var day: Int
  private var clicked: Bool
  private var isToday: Bool
  private var isCurrentMonthDay: Bool
  let reflectionStatus: ReflectionStatus

    private var textColor: Color {
      if isToday {
        return Color("blue01")
      } else if isCurrentMonthDay {
        return Color("black")
      } else {
          return Color("gray02")
      }
    }


  init(
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


    var body: some View {
      VStack {
        ZStack {
          // 회고 상태에 따른 색상 원
          switch reflectionStatus {
          case .pending:
            Circle()
              .fill(Color("blue2"))
              .frame(width: 36, height: 36)
          case .completed:
            Circle()
              .fill(Color("blue1"))
              .frame(width: 36, height: 36)
          case .none:
            EmptyView()
          }

          // 오늘이면 원 테두리
          if isToday {
            Circle()
              .stroke(Color("blue01"), lineWidth: 4)
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
