//
//  RetrospectiveView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI
import SwiftData

struct RetrospectiveView: View { //TODO: 이것만 따로 빼서 커밋하기
    
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var lottieManager: LottieManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.diaryVM) private var  diaryVM
    @State private var showAlert = false
    
    let calendar = Calendar.current
    
    
    var body: some View {
        ZStack {
            Color.lightgreen.ignoresSafeArea()
            VStack {
                topNavigationTitleView
                Spacer().frame(height: 16)
                ScrollView {
                    middleSummationView
                    Spacer().frame(height: 22)
                    previewDiaryView
                    Spacer().frame(height: 24)
                    previewQuoteView
                    Spacer().frame(height: 24)
                    previewResolutionView
                    Spacer().frame(height: 24)
                    bottomSaveButtonView
                }
                .navigationTitle("미리보기")
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.showAlert = true
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.brown01)
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
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
    
    //MARK: 네비게이션 타이틀
    private var topNavigationTitleView: some View {
        VStack {
        }
        .padding(.bottom, 16)
    }
    
    //MARK: 미들 요약 뷰
    private var middleSummationView: some View {
        VStack(alignment: .leading) {
            Text("마음을 눌러 담은 문장들, 저장 전에 다시 읽어보세요.")
                .font(Font.titleTwo)
                .foregroundStyle(Color.black01)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption2Emphasized)
                .foregroundStyle(Color.gray01)
        }
    }
    
    //MARK: 일기 미리보기 뷰
    private var previewDiaryView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("일기")
                    .font(Font.body1Semibold)
                    .foregroundStyle(Color.black01)
                Spacer()
                Button {
                    router.push(to: .inputDiaryUpdateView(date: HomeView.shardSelectedDate ?? Date(), viewType: .update))
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.brown01)
                }
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.diaryContent)
                .font(Font.body1Regular)
                .foregroundStyle(Color.black01)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
    
    //MARK: 명언 미리보기 뷰
    private var previewQuoteView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("명언")
                    .font(Font.body1Semibold)
                    .foregroundStyle(Color.black01)
                Spacer()
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.wiseSaying)
                .font(Font.body1Regular)
                .foregroundStyle(Color.black01)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
    
    //MARK: 다짐 미리보기 뷰
    private var previewResolutionView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("다짐")
                    .font(Font.body1Regular)
                    .foregroundStyle(Color.black01)
                Spacer()
                Button {
                    router.push(to: .resolutionUpdateView)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.brown01)
                }
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.resolution)
                .font(Font.body1Regular)
                .foregroundStyle(Color.black01)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
    }
    
    
    //MARK: 바텀 저장하기 버튼 뷰
    @ViewBuilder
    private var bottomSaveButtonView: some View {
        let calendar = Calendar.current
        let selectedZero = calendar.startOfDay(for: diaryVM.diary.createDate ?? Date())
        
        SaveWriteButton(title: "완료") {
            let newDiary = DiaryModelData(
                createDate: selectedZero/*diaryVM.diary.createDate?.addingTimeInterval(60 * 60 * 9) ?? Date().addingTimeInterval(60 * 60 * 9)*/,
                diaryContent: diaryVM.diary.diaryContent,
                wiseSaying: diaryVM.diary.wiseSaying,
                retrospective: diaryVM.diary.retrospective,
                resolution: diaryVM.diary.resolution,
                diaryContentSummary: diaryVM.diary.diaryContentSummary,
                wiseSayingSummary: diaryVM.diary.wiseSayingSummary,
                retrospectiveSummary: diaryVM.diary.retrospectiveSummary,
                resolutionSummary: diaryVM.diary.resolutionSummary
            )
            modelContext.insert(newDiary)
            do {
                try modelContext.save()
                print("SwiftData 저장 완료!!")
                // 바로 fetch해서 개수 확인!
                let diaries = try modelContext.fetch(FetchDescriptor<DiaryModelData>())
                print("저장 후 fetch 결과: \(diaries.count)")
            } catch {
                print("SwiftData 저장 에러: \(error.localizedDescription)")
            }
            lottieManager.shouldPlayLottie = true
            diaryVM.resetDiary()
            router.popToRootView()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48) // FIXME: 크기 동적 수정
    }
    
}

#Preview {
    NavigationStack {
        RetrospectiveView()
            .environmentObject(NavigationRouter())
    }
}

