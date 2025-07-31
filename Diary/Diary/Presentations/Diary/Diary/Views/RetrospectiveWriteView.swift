//
//  RetrospectiveWriteView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/28/25.
//

import SwiftUI
import SwiftData

struct RetrospectiveWriteView: View {
    @State private var text: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert = false
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.diaryVM) private var diaryVM
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.modelContext) private var modelContext
    
    @Query private var diaries: [DiaryModelData]
    
    // 선택한 날짜의 일기 데이터를 가져온다!
    private var myDiary: DiaryModelData? {
        let calendar = Calendar.current
        guard let selectedDate = diaryVM.diary.createDate else { return nil }
        return diaries.first { calendar.isDate($0.createDate, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        if isLoading {
            ZStack(alignment: .center) {
                Color.lightgreen.ignoresSafeArea()
                VStack {
                    LottieView(name: "loading")
                        .frame(width: 76, height: 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        } else {
            ZStack {
                Color.lightgreen.ignoresSafeArea()
                VStack {
                    topNavigationTitleView
                    middleTextFieldView
                    Spacer()
                    bottomButtonView
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            self.showAlert = true
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color.brown01)
                                .font(.system(size: 17, weight: .semibold))
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
                .navigationTitle("회고")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.horizontal, 16)
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
    }
    
    private var topNavigationTitleView: some View {
        VStack(alignment: .leading) {
            
            Spacer().frame(height: 14.5)
            
            Text("이전에 남긴 다짐을 회고하며,\n내일의 나를 위한 다짐을 다시 써 내려가요.")
                .font(Font.titleTwo)
                .foregroundStyle(Color.black01)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption2Emphasized)
                .foregroundStyle(Color.gray01)
            
            Spacer().frame(height: 4)
            
            HStack(alignment: .top, spacing: .zero) {
                Text("일기 AI요약: ")
                    .font(Font.caption2Emphasized)
                    .foregroundStyle(Color.gray01)
                Text(myDiary?.diaryContentSummary ?? "")
                    .font(Font.caption2Regular)
                    .foregroundStyle(Color.gray01)
            }
           
            Spacer().frame(height: 4)
            
            HStack(alignment: .top, spacing: .zero) {
                Text("명언: ")
                    .font(Font.caption2Emphasized)
                    .foregroundStyle(Color.gray01)
                Text(myDiary?.wiseSayingSummary ?? "")
                    .font(Font.caption2Regular)
                    .foregroundStyle(Color.gray01)
            }
            
            
            Spacer().frame(height: 4)
            
            HStack(alignment: .top, spacing: .zero) {
                Text("다짐 AI요약: ")
                    .font(Font.caption2Emphasized)
                    .foregroundStyle(Color.gray01)
                Text(myDiary?.resolutionSummary ?? "")
                    .font(Font.caption2Regular)
                    .foregroundStyle(Color.gray01)
            }
           
            
            Divider()
            
            Spacer().frame(height: 16)
            
            Text(Date().formattedWithWeekday)
                .font(Font.caption2Emphasized)
                .foregroundStyle(Color.gray01)
            
        }
    }
    
    private var middleTextFieldView: some View {
        TextField("회고를 작성해주세요.", text: $text, axis: .vertical)
            .focused($isTextFieldFocused)
            .font(Font.body1Regular)
            .foregroundStyle(Color.black01)
    }
    
    private var bottomButtonView: some View {
        HStack {
            
            Spacer()
            
            CalenderContentButton(title: "완료", imageType: .none) {
                
                isLoading = true
                diaryVM.diary.retrospective = text // 다짐 viewModel 저장
                
                Task {
                    if text.count > 25 {
                        diaryVM.diary.retrospectiveSummary = try await diaryVM.summarize(text)
                    } else {
                        diaryVM.diary.retrospectiveSummary = text
                        diaryVM.diary.retrospective = text
                    }
                    // 요약 끝, 로딩 끝, 다음 화면으로!
                    await MainActor.run {
                        
                        // 2. SwiftData에 저장 (업데이트)
                        if let target = myDiary {
                            target.retrospective = diaryVM.diary.retrospective
                            target.retrospectiveSummary = diaryVM.diary.retrospectiveSummary
                            do {
                                try modelContext.save()
//                                let diaries = try modelContext.fetch(FetchDescriptor<DiaryModelData>())
//                                print("SwiftData 업데이트 완료 후 fetch: \(diaries.map { "\($0.createDate) / \($0.retrospective)" })")
                            } catch {
                                print("SwiftData 회고 업데이트 에러: \(error.localizedDescription)")
                            }
                        }
                        isLoading = false
                        diaryVM.diary.retrospective = ""
                        diaryVM.diary.retrospectiveSummary = ""
                        router.pop()
                    }
                }
            }
            .frame(width: 80, height: 40)
        }

    }
}

#Preview {
    NavigationStack {
        RetrospectiveWriteView()
            .environmentObject(NavigationRouter())
    }
    .hideBackButton()
}
