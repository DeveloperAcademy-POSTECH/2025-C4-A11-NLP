//
//  SwiftUIView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import SwiftUI

struct HomeView: View {
    
  @State private var selectedDate: Date? = Date()
  @State private var isInfoShown: Bool = false
  @StateObject private var diaryStore = DiaryStore()
  @State private var isMonthPickerPresented = false
  @State private var selectedYear = Calendar.current.component(.year, from: Date())
  @State private var selectedMonth = Calendar.current.component(.month, from: Date())
  @State private var month: Date = Date()


    var body: some View {
        NavigationStack{
        ZStack(alignment: .topTrailing) {
            
            Color("lightBlue")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 캘린더 상단
                HStack {
                    HStack{
                        HStack{
                            Image("book icon")
                            Text("\(diaryStore.entries.count)")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(Color("gray02"))
                        }
                        
                        HStack{
                            Image(diaryStore.currentStreak > 0 ? "fire icon.fill" : "fire icon")
                              Text("\(diaryStore.currentStreak)")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundStyle(
                                      diaryStore.currentStreak > 0 ? Color("red02") : Color("gray02")
                                    )
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.leading, 16)
                    Spacer()
                    InfoButton(isInfoShown: $isInfoShown)
                }
                
                ScrollView{
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
                                .foregroundStyle(Color("blue01"))
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
                                        .foregroundStyle(Color("blue01"))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 40)
                        
                        // 글 미리보기
                        // Divider 너비 수정
                        if let entry = diaryStore.diary(for: selected)
                        {
                            VStack(alignment: .leading, spacing: 8) {
                                DiarySectionView(title: "일기", subtitle: "AI 요약", content: entry.content)
                                Divider()
                                DiarySectionView(title: "명언", subtitle: " ", content: entry.quote)
                                Divider()
                                DiarySectionView(title: "다짐", subtitle: "AI 요약", content: entry.vow)
                                Divider()
                                DiarySectionView(title: "회고", subtitle: "AI 요약", content: entry.reflection)
                                Divider()
                                
                                //회고 없을 시 "회고 쓰기" 버튼 띄우기
                                if entry.reflection == "-" {
                                    WriteReflectionButton()
                                }
                            }
                            .padding()
                            .background(Color("white"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                            else {
                            // 일기 없는 경우
                            VStack {
                                Spacer().frame(height: 100)
                                Text("오늘의 일기를 써보세요.")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color("gray01"))
                                Spacer().frame(height: 100)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    
                    Spacer()
                }
            }
            .zIndex(0)
            
            // info 설명 오버레이
            if isInfoShown {
                InfoOverlay()
                    .zIndex(1)
            }
            
            // 선택된 날짜에 일기 없을 시 보이는 "+" 버튼
            if let selected = selectedDate, diaryStore.diary(for: selected) == nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddEntryButton()
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
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
