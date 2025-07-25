//
//  ResolutionView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import SwiftUI

struct ResolutionView: View {
    let date: String //FIXME: 선택된 날짜 나오게 수정
    
    @State var text: String
    
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
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
                    router.pop()
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
            
            Text(date)
                .font(Font.caption1Emphasized)
                .foregroundStyle(Color.gray01)
            
            Spacer().frame(height: 4)
            
            HStack(spacing: .zero) {
                Text("일기 AI요약: ")
                Text("안녕")
            }
            .font(Font.caption1Emphasized)
            .foregroundStyle(Color.gray01)
            
            Spacer().frame(height: 4)
            
            HStack(spacing: .zero) {
                Text("명언: ")
                Text("안녕")
            }
            .font(Font.caption1Emphasized)
            .foregroundStyle(Color.gray01)
        }
    }
    
    //MARK: 하단 버튼 뷰
    private var bottomButtonView: some View {
        HStack {
            CalenderContentButton(title: "이전", imageType: .previous) {
                router.pop()
            }
            .frame(width: 80, height: 40)
            
            Spacer()
            
            CalenderContentButton(title: "다음", imageType: .next) {
                router.push(to: .retrospectiveView)
            }
            .frame(width: 80, height: 40)
            //            .disabled(selectedIndex == nil)
        }
    }
}

#Preview {
    ResolutionView(date: "2025년 07월 13일 (월)", text: "")
        .environmentObject(NavigationRouter())
}

