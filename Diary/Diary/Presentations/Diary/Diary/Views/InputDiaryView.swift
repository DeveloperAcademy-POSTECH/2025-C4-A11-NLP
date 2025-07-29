//
//  InputDiaryView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI
import SwiftData

struct InputDiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var diaryText: String = ""
    @State private var showRedFeedback: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var results: [(String, Double)] = []
    @FocusState private var isTextFieldFocused: Bool
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.diaryVM) private var diaryVM
    
    @State private var testLabel: String = ""
    @State private var isLoading: Bool = false   // 추가

    var viewType: ViewType
    let date: Date
    
    let analyzer: SentimentViewModel = .init()
    
    var body: some View {
        
        if isLoading {
            ZStack(alignment: .center) {
                Color.lightBlue.ignoresSafeArea()
                
                VStack() {
                    LottieView(name: "loading")
                        .frame(width: 76, height: 60)
                        Text("오늘 당신이 쓴 일기를 읽고 있어요.\n도움이 될 만한 명언들을 추천해드릴게요.")
                            .font(Font.body1Regular)
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        else {
            ZStack {
                Color.lightBlue
                VStack(spacing: .zero) {
                    topProgressBarAndNavigationTitleView
                        .padding(.horizontal, 16)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("오늘 하루는 어땠나요?")
                                .font(.system(size: 17, weight: .semibold))
                                .padding(.bottom, 8)
                            Text("\(date.formattedWithWeekday)")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                                .padding(.bottom, 27)
                            TextField("글을 작성해주세요.", text: $diaryText, axis: .vertical)
                                .font(.body)
                                .focused($isTextFieldFocused)
                            if showRedFeedback {
                                Text("*200자 이상 글을 작성해주세요.")
                                    .font(.caption2Emphasized)
                                    .foregroundStyle(Color.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .overlay(alignment: .bottom) {
                        Button {
                            switch viewType {
                            case .new:
                                results = analyzer.predictTopSentiments(for: diaryText, count: 3)
                                diaryVM.diary.createDate = self.date
                                diaryVM.diary.diaryContent = diaryText // 다이어리 컨텐츠 뷰모델 저장
                                
                                // 프로그래스바 시작
                                isLoading = true
                                
                                Task {
                                    if diaryText.count > 25 {
                                        diaryVM.diary.diaryContentSummary = try await diaryVM.summarize(diaryText)
                                    } else {
                                        diaryVM.diary.diaryContentSummary = diaryText
                                    }
                                    // 요약 끝, 로딩 끝, 다음 화면으로!
                                    await MainActor.run {
                                        isLoading = false
                                        router.push(to: .wiseSayingView(emotions: results.map { $0.0 }))
                                    }
                                }
                            case .update:
                                results = analyzer.predictTopSentiments(for: diaryText, count: 3)
                                diaryVM.diary.createDate = self.date
                                diaryVM.diary.diaryContent = diaryText // 다이어리 컨텐츠 뷰모델 저장
                                
                                // 프로그래스바 시작
                                isLoading = true
                                
                                Task {
                                    if diaryText.count > 25 {
                                        diaryVM.diary.diaryContentSummary = try await diaryVM.summarize(diaryText)
                                    } else {
                                        diaryVM.diary.diaryContentSummary = diaryText
                                    }
                                    // 요약 끝, 로딩 끝, 다음 화면으로!
                                    await MainActor.run {
                                        isLoading = false
                                        router.push(to: .wiseSayingUpdateView(emotions: results.map { $0.0 }))
                                    }
                                }
                            }
                            
                        } label: {
                            HStack(spacing: 4) {
                                Text("오늘의 명언 받기")
                            }
                            .font(.body1Semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(.horizontal, 16)
                            .background(
                                Color.blue
                            )
                            .cornerRadius(15)
                            .offset(x: shakeOffset)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    .navigationTitle("일기")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .background(Color(.systemGray6))
                .ignoresSafeArea(edges: .bottom)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            diaryVM.resetDiary()
                            router.popToRootView()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.blue)
                                .font(.system(size: 23, weight: .semibold))
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if isTextFieldFocused {
                            Button {
                                isTextFieldFocused = false
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: 상단 프로그래스 바, 네비게이션 타이틀
    private var topProgressBarAndNavigationTitleView: some View {
        //FIXME: 반복 코드 수정
        HStack {
            ProgressView(choice: true)
                .frame(width: 115, height: 4)
            ProgressView(choice: false)
                .frame(width: 115, height: 4)
            ProgressView(choice: false)
                .frame(width: 115, height: 4)
        }
    }
}


#Preview {
    NavigationStack {
        InputDiaryView(viewType: .new, date: Date())
            .environmentObject(NavigationRouter())
    }
}
