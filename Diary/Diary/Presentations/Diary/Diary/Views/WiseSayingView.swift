//
//  WiseSayingView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI

struct WiseSayingView: View {
    
    @State private var selectedIndex: Int? = nil
    @State private var selectedContent: String? = nil
    @State private var quotes: [Quote] = []
    @State private var showAlert = false
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.diaryVM) private var diaryVM
    
    var viewType: ViewType
    var emotions: [String] = []
    
    var body: some View {
        ZStack {
            Color.lightgreen.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                topProgressBarAndNavigationTitleView
                middleWiseSayingContentView
                bottomButtonView
            }
            .padding(.horizontal, 16)
            .task(id: quotes.isEmpty) {
                if quotes.isEmpty {
                    loadQuotes()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.showAlert = true
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.brown01)
                            .font(.system(size: 23, weight: .semibold))
                    }
                }
            }
            .navigationTitle("명언")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("작성 취소", isPresented: $showAlert) {
            Button("뒤로가기", role: .destructive) {
                diaryVM.resetDiary()
                router.popToRootView()
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("현재까지 입력한 내용이 저장되지 않습니다.\n정말로 취소하시겠습니까?")
        }
        
    }
    
    private func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "QuoteData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let allQuotes = try? JSONDecoder().decode([Quote].self, from: data) else {
            return
        }

        var result: [Quote] = []
        for label in emotions {
            let quotesForLabel = allQuotes.filter { $0.label == label }
            if let randomQuote = quotesForLabel.randomElement() {
                result.append(randomQuote)
            }
        }
        self.quotes = result
    }
    
    
    //MARK: 상단 프로그래스 바, 네비게이션 타이틀
    private var topProgressBarAndNavigationTitleView: some View {
        VStack {
            //FIXME: 반복 코드 수정
            HStack(spacing: 8) {
                ProgressView(choice: true)
                    .frame(width: 115, height: 4)
                ProgressView(choice: true)
                    .frame(width: 115, height: 4)
                ProgressView(choice: false)
                    .frame(width: 115, height: 4)
            }
            .padding(.bottom, 16)
        }
    }
    
    //MARK: 미들 명언 데이터 뷰
    private var middleWiseSayingContentView: some View {
        
        VStack(alignment: .leading) {
            Text("비슷한 길을 걷는 러너들에게 힘이 된 한 줄이에요.\n오늘의 다짐엔 어떤 명언이 어울릴까요?")
                .font(Font.titleTwo)
                .foregroundStyle(Color.black01)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption2Emphasized)
                .foregroundStyle(.gray01)
            
            Spacer().frame(height: 32)
            
            //FIXME: JSON에서 불러오는 데이터 변경하기
            ForEach(Array(quotes.enumerated()), id: \.offset) { index, quote in
                WiseSayingContentButton(
                    content: quote.quote,
                    respondent: quote.respondent,
                    source: quote.quoteSource ?? "",
                    isSelected: selectedIndex == index
                ) {
                    selectedContent = quote.quote
                    selectedIndex = index
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 110) // 고정 크기에서 변경
                .padding(.bottom, 24)
            }
            Spacer()
        }
        
    }
    
    //MARK: 하단 버튼 뷰
    @ViewBuilder
    private var bottomButtonView: some View {
        HStack {
            CalenderContentButton(title: "이전", imageType: .previous) {
                router.pop()
            }
            .frame(width: 98, height: 48)
            
            Spacer()
            
            switch viewType {
            case .new:
                CalenderContentButton(title: "다음", imageType: .next) {
                    diaryVM.diary.wiseSaying = selectedContent ?? ""  //FIXME: 명언으로 수정
                    diaryVM.diary.wiseSayingSummary = selectedContent ?? ""
                    router.push(to: .resolutionView)
                }
                .frame(width: 98, height: 48)
                .disabled(selectedIndex == nil)
            case .update:
                CalenderContentButton(title: "완료", imageType: .none) {
                    diaryVM.diary.wiseSaying = selectedContent ?? ""  //FIXME: 명언으로 수정
                    diaryVM.diary.wiseSayingSummary = selectedContent ?? ""
                    router.push(to: .retrospectiveView)
                }
                .frame(width: 98, height: 48)
                .disabled(selectedIndex == nil)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WiseSayingView(viewType: .new)
            .environmentObject(NavigationRouter())
    }
}
