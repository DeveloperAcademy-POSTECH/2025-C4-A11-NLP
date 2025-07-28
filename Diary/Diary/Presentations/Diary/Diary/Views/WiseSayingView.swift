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
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.diaryVM) private var diaryVM
    
    var viewType: ViewType
    
    var body: some View {
        
        VStack {
            topProgressBarAndNavigationTitleView
            middleWiseSayingContentView
            bottomButtonView
        }
        .padding(.horizontal, 16)
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
            
            WiseSayingContentButton(
                content: "하루하루는 성실하게. 인생 자체는 되는대로",
                respondent: "Libby",
                source: "이동진",
                isSelected: selectedIndex == 0
            ) {
                selectedContent = "하루하루는 성실하게. 인생 자체는 되는대로" //FIXME: 로직수정
                selectedIndex = 0
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) //FIXME: 높이 수정
            
            Spacer().frame(height: 24)
            
            WiseSayingContentButton(
                content: "무슨 생각을 해 그냥 하는거지",
                respondent: "Gabi",
                source: "김연아",
                isSelected: selectedIndex == 1
            ) {
                selectedContent = "무슨 생각을 해 그냥 하는거지" //FIXME: 로직수정
                selectedIndex = 1
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110, alignment: .leading) //FIXME: 높이 수정
            
            Spacer().frame(height: 24)
            
            WiseSayingContentButton(
                content: "나를 죽이지 못하는 것은 나를 더 강하게 만든다.",
                respondent: "Peppr",
                source: "니체",
                isSelected: selectedIndex == 2,
                
            ) {
                selectedContent = "나를 죽이지 못하는 것은 나를 더 강하게 만든다." //FIXME: 로직수정
                selectedIndex = 2
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) //FIXME: 높이 수정
            
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
                    router.push(to: .resolutionView)
                }
                .frame(width: 80, height: 40)
                .disabled(selectedIndex == nil)
            case .update:
                CalenderContentButton(title: "완료", imageType: .none) {
                    diaryVM.diary.wiseSaying = selectedContent ?? ""  //FIXME: 명언으로 수정
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
