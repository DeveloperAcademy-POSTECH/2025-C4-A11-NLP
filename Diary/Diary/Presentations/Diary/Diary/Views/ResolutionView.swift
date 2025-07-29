//
//  ResolutionView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI

struct ResolutionView: View {
    
    @State var text: String = ""
    
    var viewType: ViewType
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.diaryVM) private var diaryVM
    
    @State private var isLoading: Bool = false   // 추가
    var body: some View {
        if isLoading {
            ZStack(alignment: .center) {
                VStack() {
                    LottieView(name: "loading")
                        .frame(width: 76, height: 60)
                    Text("오늘 당신이 쓴 일기를 읽고 있어요.\n도움이 될 만한 명언들을 추천해드릴게요.")
                        .font(Font.body2Regular)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        } else {
            VStack(alignment: .leading) {
                topProgressBarAndNavigationTitleView
                middleSummationView
                
                Spacer().frame(height: 16)
                
                TextEditor(text: $text)
                    .frame(maxHeight: .infinity)
                    .overlay(
                        Group {
                            if text.isEmpty {
                                VStack {
                                    Text("다짐을 작성해보세요.")
                                        .foregroundStyle(Color.gray)
                                        .padding([.top,.horizontal], 8)
                                        .allowsHitTesting(false)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    Spacer()
                                }
                            }
                        }
                    )
                
                Spacer()
                bottomButtonView
            }
            
            .padding(.horizontal, 16)
            .task {
                self.text = diaryVM.diary.resolution
            }
        }
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
                ProgressView(choice: true)
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
                Text("다짐")
                    .font(.title1Emphasized)
                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
    
    //MARK: 미들 요약 뷰
    private var middleSummationView: some View {
        VStack(alignment: .leading) {
            Text("쓴 일기와 선택한 러너의 명언을 바탕으로,\n내일을 위한 다짐을 적어보세요.")
                .font(Font.title22)
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption1Emphasized)
                .foregroundStyle(Color.gray01)
            
            Spacer().frame(height: 4)
            
            HStack(spacing: .zero) {
                Text("일기 AI요약: ")
                Text(diaryVM.diary.diaryContentSummary)
            }
            .font(Font.caption1Emphasized)
            .foregroundStyle(Color.gray01)
            
            Spacer().frame(height: 4)
            
            HStack(spacing: .zero) {
                Text("명언: ")
                Text(diaryVM.diary.wiseSaying)
            }
            .font(Font.caption1Emphasized)
            .foregroundStyle(Color.gray01)
        }
    }
    
    @ViewBuilder
    private var bottomButtonView: some View {
        switch viewType {
        case .new:
            HStack {
                CalenderContentButton(title: "이전", imageType: .previous) {
                    router.pop()
                }
                .frame(width: 80, height: 40)
                
                Spacer()
                
                CalenderContentButton(title: "다음", imageType: .next) {
                    
                    isLoading = true
                    diaryVM.diary.resolution = text // 다짐 viewModel 저장
                    Task {
                        if text.count > 25 {
                            diaryVM.diary.resolutionSummary = try await diaryVM.summarize(text)
                        } else {
                            diaryVM.diary.resolutionSummary = text
                        }
                        // 요약 끝, 로딩 끝, 다음 화면으로!
                        await MainActor.run {
                            isLoading = false
                            router.push(to: .retrospectiveView)
                        }
                    }
                }
                .frame(width: 80, height: 40)
            }
        case .update:
            HStack {
                Spacer()
                CalenderContentButton(title: "완료", imageType: .none) {
                    diaryVM.diary.resolution = text // 다짐 viewModel 저장
                    isLoading = true
                    Task {
                        if text.count > 25 {
                            diaryVM.diary.resolutionSummary = try await diaryVM.summarize(text)
                        } else {
                            diaryVM.diary.resolutionSummary = text
                        }
                        // 요약 끝, 로딩 끝, 다음 화면으로!
                        await MainActor.run {
                            isLoading = false
                            router.pop()
                        }
                    }
                }
                .frame(width: 80, height: 40)
                Spacer()
            }
        }
    }
}

#Preview {
    ResolutionView(text: "", viewType: .update)
        .environmentObject(NavigationRouter())
}

