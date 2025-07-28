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
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.diaryVM) private var diaryVM
    
    var viewType: ViewType
    var emotions: [String] = []
    
    var body: some View {
        VStack {
            topProgressBarAndNavigationTitleView
            middleWiseSayingContentView
            bottomButtonView
        }
        .padding(.horizontal, 16)
        .onAppear {
            loadQuotes()
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
            HStack {
                Button {
                    diaryVM.resetDiary()
                    router.popToRootView()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                        .font(.system(size: 23, weight: .semibold))
                }
                Spacer()
                Text("명언")
                    .font(.title1Emphasized)
                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
    
    //MARK: 미들 명언 데이터 뷰
    private var middleWiseSayingContentView: some View {
        
        VStack(alignment: .leading) {
            Text("비슷한 길을 걷는 러너들에게 힘이 된 한 줄이에요.\n오늘의 다짐엔 어떤 명언이 어울릴까요?")
                .font(Font.title22)
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption1Emphasized)
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
                .frame(height: 110)
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
            .frame(width: 80, height: 40)
            
            Spacer()
            
            switch viewType {
            case .new:
                CalenderContentButton(title: "다음", imageType: .next) {
                    diaryVM.diary.wiseSaying = selectedContent ?? ""  //FIXME: 명언으로 수정
                    diaryVM.diary.wiseSayingSummary = selectedContent ?? ""
                    router.push(to: .resolutionView)
                }
                .frame(width: 80, height: 40)
                .disabled(selectedIndex == nil)
            case .update:
                CalenderContentButton(title: "완료", imageType: .none) {
                    diaryVM.diary.wiseSaying = selectedContent ?? ""  //FIXME: 명언으로 수정
                    diaryVM.diary.wiseSayingSummary = selectedContent ?? ""
                    router.push(to: .retrospectiveView)
                }
                .frame(width: 80, height: 40)
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
