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
    
    
    var body: some View {
        ZStack {
            Color.lightBlue.ignoresSafeArea()
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
            }
            .padding(.horizontal, 16)
        }
    }
    
    //MARK: 네비게이션 타이틀
    private var topNavigationTitleView: some View {
        VStack {
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.blue)
                        .font(.system(size: 23, weight: .semibold))
                }
                Spacer()
                Text("미리보기")
                    .font(.title1Emphasized)
                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
    
    //MARK: 미들 요약 뷰
    private var middleSummationView: some View {
        VStack(alignment: .leading) {
            Text("마음을 눌러 담은 문장들, 저장 전에 다시 읽어보세요.")
                .font(Font.title22)
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            Text(diaryVM.diary.createDate?.formattedWithWeekday ?? Date().formattedWithWeekday)
                .font(Font.caption1Emphasized)
                .foregroundStyle(Color.gray01)
        }
    }
    
    //MARK: 일기 미리보기 뷰
    private var previewDiaryView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("일기")
                    .font(Font.body2Emphasized)
                    .foregroundStyle(Color.black)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Color.blue)
                }
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.diaryContent)
                .font(Font.body2Regular)
                .foregroundStyle(Color.black)
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
                    .font(Font.body2Emphasized)
                    .foregroundStyle(Color.black)
                Spacer()
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.wiseSaying)
                .font(Font.body2Regular)
                .foregroundStyle(Color.black)
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
                    .font(Font.body2Emphasized)
                    .foregroundStyle(Color.black)
                Spacer()
                Button {
                    router.push(to: .resolutionUpdateView)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Color.blue)
                }
            }
            Spacer().frame(height: 8)
            Text(diaryVM.diary.resolution)
                .font(Font.body2Regular)
                .foregroundStyle(Color.black)
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
    private var bottomSaveButtonView: some View {
        SaveWriteButton(title: "저장하기") {
            
            // 1. diaryVM.diary 데이터를 받아 SwiftData로 변환
            let newDiary = DiaryModelData(
                createDate: diaryVM.diary.createDate ?? Date(),
                diaryContent: diaryVM.diary.diaryContent,
                wiseSaying: diaryVM.diary.wiseSaying,
                retrospective: diaryVM.diary.retrospective,
                resolution: diaryVM.diary.resolution,
                summary: diaryVM.diary.summary
            )
            
            // 2. modelContext에 저장
            modelContext.insert(newDiary)
            try? modelContext.save()
            
            
            lottieManager.shouldPlayLottie = true  // Lottie 실행
            diaryVM.resetDiary() // 뷰모델 초기화
            router.popToRootView()
        }
        .frame(width: 100, height: 44) // FIXME: 크기 동적 수정
    }
    
}

#Preview {
    RetrospectiveView()
        .environmentObject(NavigationRouter())
}
