//
//  InputDiaryView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI

struct InputDiaryView: View {
//    @Environment(\.modelContext) private var modelContext
    @State private var diaryText: String = ""
    @State private var showRedFeedback: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    

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

            VStack(alignment: .leading) {
                Text("2025년 07월 13일 (월)")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ZStack(alignment: .topLeading) {
                if diaryText.isEmpty {
                        Text("오늘의 하루는 어땠나요? 오늘 느낀 감정들을 솔직하게 써보세요. (200자 이상)")
                            .font(.body)
                            .foregroundStyle(Color.gray.opacity(0.4))
                            .padding(.horizontal, 20)
                            .padding(.top, 27)
                    }
                TextEditor(text: $diaryText)
                    .font(.body)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: .infinity)
                    .focused($isTextFieldFocused)
            }
            
            HStack {
                Spacer()
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
                        print("다음 뷰로 이동")
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("오늘의 명언 받기")
                    }
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        showRedFeedback ? Color.red :
                        (diaryText.count < 200 ? Color.gray.opacity(0.3) : Color.blue)
                    )
                    .cornerRadius(10)
                    .offset(x: shakeOffset)
                }
                Spacer()
            }
            .padding(.trailing, 16)
            .padding(.bottom, 34)
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
