//
//  WiseSayingView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI

struct WiseSayingView: View {
    
    @State private var selectedIndex: Int? = nil
    
    let date: String //FIXME: 선택된 날짜 나오게 수정
    
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
                    print("뒤로가기")
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
            
            Text(date)
                .font(Font.caption1Emphasized)
                .foregroundStyle(.gray01)
            
            Spacer().frame(height: 32)
            
            WiseSayingContentButton(
                content: "",
                respondent: "",
                source: "",
                isSelected: selectedIndex == 0
            ) {
                selectedIndex = 0
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) //FIXME: 높이 수정
            
            Spacer().frame(height: 24)
            
            WiseSayingContentButton(
                content: "",
                respondent: "",
                source: "",
                isSelected: selectedIndex == 1
            ) {
                selectedIndex = 1
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) //FIXME: 높이 수정
            
            Spacer().frame(height: 24)
            
            WiseSayingContentButton(
                content: "",
                respondent: "",
                source: "",
                isSelected: selectedIndex == 2
            ) {
                selectedIndex = 2
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) //FIXME: 높이 수정
            
            Spacer()
        }
        
    }
    
    //MARK: 하단 버튼 뷰
    private var bottomButtonView: some View {
        HStack {
            CalenderContentButton(title: "이전", imageType: .previous) {
                
            }
            .frame(width: 80, height: 40)
            
            Spacer()
            
            CalenderContentButton(title: "다음", imageType: .next) {
                //TODO: 네비게이션 라우터 추가
            }
            .frame(width: 80, height: 40)
            .disabled(selectedIndex == nil)
        }
    }
}

#Preview {
    NavigationStack {
        WiseSayingView(date: "2025년 07월 13일 (월)")
    }
}
