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
    
    let analyzer: SentimentViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            SegmentedProgressBar(totalSegments: 3, currentSegment: 1)
            
            HStack {
                Button {
                    print("뒤로가기")
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                        .font(.system(size: 17, weight: .semibold))
                }
                Spacer()
                Text("일기")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                if isTextFieldFocused {
                    Button {
                        isTextFieldFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            
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
                    if diaryText.count < 200 {
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
                        print("다음 뷰")
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
                            (diaryText.count < 200 ? Color.gray.opacity(0.3) : Color.blue)
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
}

struct SegmentedProgressBar: View {
    let totalSegments: Int
    let currentSegment: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSegments, id: \.self) { index in
                Capsule()
                    .fill(index < currentSegment ? Color.purple : Color.gray.opacity(0.3))
                    .frame(height: 6)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}


#Preview {
    InputDiaryView()
}
