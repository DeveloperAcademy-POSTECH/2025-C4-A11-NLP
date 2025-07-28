//
//  SwiftUIView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var selectedDate: Date? = Date()
    @State private var isInfoShown: Bool = false
    @StateObject private var diaryStore = DiaryStore()
    @State private var isMonthPickerPresented = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var month: Date = Date()
    
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var lottieManager :LottieManager = .init()
    private var lottieType: LottieType = .confettie
    
    static var shardSelectedDate: Date? //FIXME: 네비게이션 date주입을 위한 임시 변수
    
    @Query(sort: \DiaryModelData.createDate, order: .reverse) private var diaries: [DiaryModelData]
    
    var body: some View {
        NavigationStack(path: $router.destination) {
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

                            HStack {
                                let wroteToday = diaryStore.diary(for: Date()) != nil
                                                        let streak = wroteToday ? diaryStore.currentStreak : diaryStore.pastStreak
                                                        let iconName = (wroteToday && streak > 0) ? "fire icon.fill" : "fire icon"
                                                        let color = wroteToday ? Color("red02") : Color("gray02")

                                                        Image(iconName)
                                                        Text("\(streak)")
                                                            .font(.system(size: 20))
                                                            .bold()
                                                            .foregroundStyle(color)
                                                    }
                                                    .padding(.horizontal, 16)
                                  }
                        .padding()
                        Spacer()
                        // info 버튼
                        InfoButton(isInfoShown: $isInfoShown)
                    }
                    
                    // 캘린더 뷰
                    CalendarView(
                        month: $month,
                        clickedCurrentMonthDates: $selectedDate,
                        isMonthPickerPresented: $isMonthPickerPresented,
                        diaryStore: diaryStore
                    )
                    .onChange(of: selectedDate) { _, newValue in
                        if let date = newValue {
                            print("Selected date: \(date)")
                        }
                    }
                    
                    
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
                        .padding(.top, 16)
                        
                        // 글 미리보기
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
                                    WriteReflectionButton()
                                }
                            }
                            .padding()
                            .padding(.leading, 16)
                            .padding(.top, 30)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        } else {
                            // 일기 없는 경우
                            VStack {
                                Text("오늘의 일기를 써보세요.")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color("gray01"))
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
                    InfoOverlay()
                        .zIndex(1)
                }
                
                // 선택된 날짜에 일기 없을 시 보이는 "+" 버튼
                if let selected = selectedDate, diaryStore.diary(for: selected) == nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddEntryButton() {
                                HomeView.shardSelectedDate = selected //FIXME: 네비게이션 date주입을 위한 임시 변수
                                router.push(to: .inputDiaryView(date: selected))
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
                
                // Lottie 애니메이션 (shouldPlayLottie가 true일 때만)
                if lottieManager.shouldPlayLottie {
                    LottieView(name: lottieType.lottie)
                        .frame(width: 200, height: 200)
                        .onAppear { //FIXME: 코드 수정
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                lottieManager.shouldPlayLottie = false
                            }
                        }
                        .transition(.opacity)
                }
            }
            .navigationDestination(for: NavigationDestination.self, destination: { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(router)
            })
            .task { // 날짜가 선택되지 않을때는 오늘 날짜로 넣어두기
                if selectedDate == nil {
                    selectedDate = Date()
                }
            }
        }
        .environmentObject(lottieManager)
        
    }
}



#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}

