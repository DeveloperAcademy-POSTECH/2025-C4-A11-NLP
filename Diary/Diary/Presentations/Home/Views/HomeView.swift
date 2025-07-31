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
    @Environment(\.diaryVM) private var diaryVM
    @StateObject private var lottieManager :LottieManager = .init()
    private var lottieType: LottieType = .confettie
    
    static var shardSelectedDate: Date? //FIXME: 네비게이션 date주입을 위한 임시 변수
    
    @Query private var diaries: [DiaryModelData]
    
    @State private var streakCount: Int = 0
    
    var body: some View {
        NavigationStack(path: $router.destination) {
            ZStack(alignment: .topTrailing) {
                
                Color.lightgreen.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // info 버튼
                    HStack {
                        Text("Quotiary")
                            .font(Font.ppAcma26)
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        Image(.greenbook)
                        Spacer().frame(width: 4)
                        Text("\(diaries.count)")
                            .font(Font.title1Emphasized)
                            .foregroundStyle(diaries.count == 0 ? Color.gray03 : Color.green1) //FIXME: 색 한번 더 확인
                        
                        Spacer().frame(width: 16)
                        
                        
                        Image(.fire)
                        Text("\(streakCount)")
                            .font(Font.title1Emphasized)
                            .foregroundStyle(streakCount == 0 ? Color.gray03 : Color.red01)
                        
                        
                        InfoButton(isInfoShown: $isInfoShown)
                    }
                    .padding(.horizontal, 16)
                    
                    
                    Spacer().frame(height: 25)
                    
                    // 캘린더 뷰
                    CalendarView(
                        month: $month,
                        clickedCurrentMonthDates: $selectedDate,
                        isMonthPickerPresented: $isMonthPickerPresented,
                        diaryStore: diaryStore
                    )
                    .onChange(of: selectedDate) { _, newValue in
                        if let date = newValue {
                            diaryVM.diary.createDate = date //FIXME: 로직 수정해야 될 것 같음
                            print("Selected date: \(date)")
                        }
                    }
                    
                    
                    // 캘린더 뷰 아래쪽
                    if let selected = selectedDate {
                        VStack {
                            HStack {
                                // 날짜 텍스트
                                Text(selected.formattedWithWeekday)
                                    .font(Font.title1Emphasized)
                                    .foregroundStyle(Color.brown01)
                                
                                Spacer()
                                
                                // 일기가 있는 경우에만 화살표 표시
                                if diaryStore.diary(for: selected) != nil {
                                    Button(action: {
                                        router.push(to: .diaryDetailView)
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .font(Font.titleOne)
                                            .foregroundStyle(Color.brown01)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            
                            Spacer().frame(height: 8)
                        }
                        
                        // 글 미리보기
                        if let entry = diaryStore.diary(for: selected) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top){
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("일기")
                                            .font(Font.body1Semibold)
                                            .foregroundStyle(Color.black01)
                                        Text("AI 요약")
                                            .font(Font.caption3)
                                            .foregroundStyle(Color.black01)
                                    }
                                    .frame(width: 40, alignment: .leading)
                                    Text(entry.content)
                                        .font(Font.body1Regular)
                                        .foregroundStyle(Color.black01)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                                Divider()
                                HStack(alignment: .top) {
                                    Text("명언")
                                        .font(Font.body1Semibold)
                                        .foregroundStyle(Color.black01)
                                        .frame(width: 40, alignment: .leading)
                                    Text(entry.quote)
                                        .font(Font.body1Regular)
                                        .foregroundStyle(Color.black01)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                                Divider()
                                HStack(alignment: .top){
                                    VStack(alignment: .leading, spacing: 2){
                                        Text("다짐")
                                            .font(Font.body1Semibold)
                                            .foregroundStyle(Color.black01)
                                        Text("AI 요약")
                                            .font(Font.caption3)
                                            .foregroundStyle(Color.black01)
                                    }
                                    .frame(width: 40, alignment: .leading)
                                    Text(entry.vow)
                                        .font(Font.body1Regular)
                                        .foregroundStyle(Color.black01)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                                Divider()
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("회고")
                                            .font(Font.body1Semibold)
                                            .foregroundStyle(Color.black01)
                                        Text("AI 요약")
                                            .font(Font.caption3)
                                            .foregroundStyle(Color.black01)
                                    }
                                    .frame(width: 40, alignment: .leading)
                                    Text(entry.reflection)
                                        .font(Font.body1Regular)
                                        .foregroundStyle(Color.black01)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                                Divider()
                                //회고 없을 시 "회고 쓰기" 버튼 띄우기
                                //FIXME: 이게 맞는 걸까
                                if entry.reflection == "" {
                                    WriteReflectionButton() {
                                        router.push(to: .retrospectiveWriteView)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
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
                                    .font(Font.body1Regular)
                                    .foregroundStyle(Color.gray01)
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
                    selectedDate = Date().addingTimeInterval(60 * 60 * 9)
                    //                    let todayStartOfDay = Calendar.current.startOfDay(for: Date())
                    //                       selectedDate = todayStartOfDay
                    //                       diaryVM.diary.createDate = todayStartOfDay
                }
                // print("diaries : \(diaries.first?.createDate)")
            }
            //TODO: 로직 살펴보기
            .onAppear {
                diaryStore.update(with: diaries) // SwiftData → entries 반영
                streakCount = calculateStreak(from: diaries)
                
                //FIXME: 버그 우회 임시
                if router.destination.isEmpty {
                    let today = Calendar.current.startOfDay(for: Date())
                    selectedDate = today
                    diaryVM.diary.createDate = today
                }
            }
            .onChange(of: diaries) { _, newDiaries in
                diaryStore.update(with: newDiaries) // 데이터 변동 반영
                streakCount = calculateStreak(from: newDiaries)
            }
            
        }
        .environmentObject(lottieManager)
        
    }
    
    // Streak 계산 함수
    private func calculateStreak(from diaries: [DiaryModelData]) -> Int {
        guard !diaries.isEmpty else { return 0 }
        
        let diaryDatesSet = Set(diaries.map { Calendar.current.startOfDay(for: $0.createDate) })
        
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        // 오늘 작성했는지 여부 체크
        if !diaryDatesSet.contains(currentDate) {
            // 오늘 작성된 기록이 없다면 하루 전으로 옮겨서 체크
            guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return 0 }
            currentDate = yesterday
        }
        
        // 연속 기록 여부 체크
        while diaryDatesSet.contains(currentDate) {
            streak += 1
            guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDate
        }
        
        return streak
    }
}



#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(NavigationRouter())
    }
}

