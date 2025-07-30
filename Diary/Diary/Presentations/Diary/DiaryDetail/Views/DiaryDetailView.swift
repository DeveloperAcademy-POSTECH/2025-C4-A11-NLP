//
//  DiaryDetailView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//
import SwiftUI
import SwiftData

struct DiaryDetailView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @Environment(\.diaryVM) private var diaryVM
    @Environment(\.modelContext) private var modelContext
    
    @Query private var diaries: [DiaryModelData]
    
    // 선택한 날짜의 일기 데이터를 가져온다!
    private var myDiary: DiaryModelData? {
        let calendar = Calendar.current
        guard let selectedDate = diaryVM.diary.createDate else { return nil }
        return diaries.first { calendar.isDate($0.createDate, inSameDayAs: selectedDate) }
    }
    
    
    var body: some View {
        ZStack {
            Color.lightgreen.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    previewDiaryView
                    previewQuoteView
                    previewResolutionView
                    previewRestrospectiveView
                }
            }
            .navigationTitle(myDiary?.createDate.formattedWithWeekdayNavi ?? Date().formattedWithWeekdayNavi)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.brown01)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
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
                        .font(.system(size: 17))
                        .foregroundStyle(Color.brown01)
                }
            }
            Spacer().frame(height: 8)
            Text(myDiary?.diaryContent ?? "")
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
            Text(myDiary?.wiseSaying ?? "")
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
            Text(myDiary?.resolution ?? "")
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
    
    //MARK: 회고 미리보기 뷰
    private var previewRestrospectiveView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("회고")
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
            Text(myDiary?.retrospective ?? "")
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
}

#Preview {
    NavigationStack {
        DiaryDetailView()
            .environmentObject(NavigationRouter())
    }
}
