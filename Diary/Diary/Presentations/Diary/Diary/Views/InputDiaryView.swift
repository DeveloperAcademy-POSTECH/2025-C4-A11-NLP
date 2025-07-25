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
    
    let analyzer: SentimentViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            topProgressBarAndNavigationTitleView
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("오늘 하루는 어땠나요?")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.bottom, 8)
                    Text("2025년 07월 13일 (월)")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .padding(.bottom, 27)
                    TextField("오늘 느낀 감정들을 써보세요. (200자 이상)", text: $diaryText, axis: .vertical)
                        .font(.body)
                        .focused($isTextFieldFocused)
                    
                    if showRedFeedback {
                        Text("*200자 이상 글을 작성해주세요.")
                            .font(.caption1Emphasized)
                            .foregroundStyle(Color.red)
                    }
                    //mlmodel 테스트
//                    ForEach(results, id: \.0) { label, confidence in
//                        Text("• \(label): \(confidence, specifier: "%.1f")%")
//                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .overlay(alignment: .bottom) {
                Button {
                    //FIXME: 200 글자 로직 빼기
                    if diaryText.count < 5 {
                        withAnimation(.default) {
                            showRedFeedback = true
                        }
                        withAnimation(
                            Animation.default
                                .repeatCount(5, autoreverses: true)
                                .speed(6)
                        ) {
                            shakeOffset = 10
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showRedFeedback = false
                            shakeOffset = 0
                        }
                        
                        
                    } else {
                        results = analyzer.predictTopSentiments(for: diaryText, count: 3)
                        router.push(to: .wiseSayingView)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("오늘의 명언 받기")
                    }
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .background(
                        showRedFeedback ? Color.red :
                            (diaryText.count < 5 ? Color.gray.opacity(0.3) : Color.blue)
                    )
                    .cornerRadius(15)
                    .offset(x: shakeOffset)
                }
                Spacer()
            }
            .padding(.bottom, 32)
        }
            .background(Color(.systemGray6))
            .ignoresSafeArea(edges: .bottom)
        
    }
    
    
    
    //MARK: 상단 프로그래스 바, 네비게이션 타이틀
    private var topProgressBarAndNavigationTitleView: some View {
        VStack {
            //FIXME: 반복 코드 수정
            HStack(spacing: 8) {
                ProgressView(choice: true)
                    .frame(width: 115, height: 4)
                ProgressView(choice: false)
                    .frame(width: 115, height: 4)
                ProgressView(choice: false)
                    .frame(width: 115, height: 4)
            }
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                        .font(.system(size: 23, weight: .semibold))
                }
                Spacer()
                Text("일기")
                    .font(.title1Emphasized)
                Spacer()
                if isTextFieldFocused {
                    Button {
                        isTextFieldFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}


#Preview {
    InputDiaryView()
        .environmentObject(NavigationRouter())
}
