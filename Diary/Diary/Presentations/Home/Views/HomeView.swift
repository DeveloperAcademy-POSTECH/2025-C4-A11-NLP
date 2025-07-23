//
//  SwiftUIView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import SwiftUI

enum ReflectionStatus {
  case none      // 일기 없음
  case pending   // 회고 없음 ("-")
  case completed // 회고 완료
}

struct HomeView: View {
  @State private var selectedDate: Date? = Date()
  @State private var isInfoShown: Bool = false
  @StateObject private var diaryStore = DiaryStore()
  @State private var isMonthPickerPresented = false
  @State private var selectedYear = Calendar.current.component(.year, from: Date())
  @State private var selectedMonth = Calendar.current.component(.month, from: Date())
  @State private var month: Date = Date()


  var body: some View {
    ZStack(alignment: .topTrailing) {
      VStack(spacing: 0) {
        // info 버튼
        HStack {
          Spacer()
          Button(action: {
            isInfoShown.toggle()
          }) {
            Image(systemName: "info.circle.fill")
              .font(.system(size: 24))
              .foregroundStyle(Color(red: 222/255, green: 223/255, blue: 224/255))
              .padding()
          }
        }

        // 캘린더 뷰
          CalendarView(
            month: $month,
            clickedCurrentMonthDates: $selectedDate,
            isMonthPickerPresented: $isMonthPickerPresented,
            diaryStore: diaryStore
          )


        // 캘린더 뷰 아래쪽
          if let selected = selectedDate {
            HStack {
            // 날짜 텍스트
              Text(selected.formattedWithWeekday)
                .font(.system(size: 20))
                .foregroundStyle(Color(red: 26/255, green: 26/255, blue: 26/255))
                .bold()

              Spacer()

              // 일기가 있는 경우에만 화살표 표시
                if diaryStore.diary(for: selected) != nil {
                    Button(action: {
                        // 일기 상세 보기 뷰 네비게이션
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(Color(red: 23/255, green: 76/255, blue: 192/255))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

          //글 미리보기
          if let entry = diaryStore.diary(for: selected) {
              VStack(alignment: .leading, spacing: 8){
                  HStack(alignment: .top){
                      VStack(alignment: .leading, spacing: 2){
                          Text("일기")
                              .font(.system(size: 17))
                          Text("AI 요약")
                              .font(.system(size: 13))
                      }
                      Text(entry.content)
                          .font(.system(size: 17))
                          .multilineTextAlignment(.leading)
                          .lineLimit(nil)
                  }
                  Divider()
                  HStack(alignment: .top){
                      Text("명언")
                          .font(.system(size: 17))
                      Text(entry.quote)
                          .font(.system(size: 17))
                          .multilineTextAlignment(.leading)
                          .lineLimit(nil)
                  }
                  Divider()
                  HStack(alignment: .top){
                      VStack(alignment: .leading, spacing: 2){
                          Text("다짐")
                              .font(.system(size: 17))
                          Text("AI 요약")
                              .font(.system(size: 13))
                      }
                      Text(entry.vow)
                          .font(.system(size: 17))
                          .multilineTextAlignment(.leading)
                          .lineLimit(nil)
                  }
                  Divider()
                  HStack(alignment: .top) {
                      VStack(alignment: .leading, spacing: 2) {
                          Text("회고")
                              .font(.system(size: 17))
                          Text("AI 요약")
                              .font(.system(size: 13))
                      }
                      Text(entry.reflection)
                          .font(.system(size: 17))
                          .multilineTextAlignment(.leading)
                          .lineLimit(nil)
                  }
                  Divider()
                  //회고 없을 시 "회고 쓰기" 버튼 띄우기
                  if entry.reflection == "-" {
                              Button(action: {
                                  // 회고 작성 화면으로 이동
                              }) {
                                  Text("회고 쓰기")
                                      .bold()
                                      .font(.system(size: 13))
                                      .foregroundStyle(Color(red: 23/255, green: 76/255, blue: 192/255))
                                      .frame(width: 80, height: 40)
                                      .background(Color(red: 225/255, green: 233/255, blue: 250/255))
                                      .clipShape(RoundedRectangle(cornerRadius: 10))
                                      .padding(.bottom, 30)
                                      .padding(.trailing, 20)
                              }
                              .frame(maxWidth: .infinity, alignment: .center)
                              .padding(.top, 20)
                          }
                      }
                      .padding()
                      .padding(.leading, 16)
                      .padding(.top, 30)
                  } else {
            // 일기 없는 경우
            VStack {
              Text("오늘의 일기를 써보세요.")
                .font(.system(size: 17))
                .foregroundStyle(Color(red: 207/255, green: 208/255, blue: 209/255))
              Spacer().frame(height: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }

        Spacer()
      }
      .zIndex(0)

      // info 설명 오버레이
      if isInfoShown {
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

      // 선택된 날짜에 일기 없을 시 보이는 "+" 버튼
        if let selected = selectedDate, diaryStore.diary(for: selected) == nil {
          VStack {
            Spacer()
            HStack {
              Spacer()
              Button(action: {
                // 새 일기 작성 화면으로 이동
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
          .zIndex(1)
        }

        //datepicker에서 선택한 연월로 캘린더 갱신
        if isMonthPickerPresented {
            MonthYearPickerPopup(
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                isPresented: $isMonthPickerPresented,
                onConfirm: {
                    if let newDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) {
                      month = newDate
                    }
                  }
            )
            .zIndex(1)
        }

    }
  }
}

// 연월 datepicker
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

  let years = Array(2020...2030)
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
          .frame(width: 160)
          .clipped()

          Picker("월", selection: $selectedMonth) {
            ForEach(months, id: \.self) { month in
                Text(String(format: "%d월", month)).tag(month)
            }
          }
          .labelsHidden()
          .frame(width: 160)
          .clipped()
        }
        .pickerStyle(.wheel)
        .padding(.vertical)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

        Button(action: {
          isPresented = false
          onConfirm()
        }) {
          Text("확인")
            .bold()
            .frame(width: 80, height: 40)
            .background(Color(red: 225/255, green: 233/255, blue: 250/255))
            .foregroundStyle(Color(red: 23/255, green: 76/255, blue: 192/255))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
      }
    }
  }
}

#Preview {
    HomeView()
}
