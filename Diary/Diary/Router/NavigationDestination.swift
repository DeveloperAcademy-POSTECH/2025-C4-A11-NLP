//
//  NavigationDestination.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftUI

enum NavigationDestination: Equatable, Hashable {
    case home //FIXME: 임시) 케이스 수정하기
    case inputDiaryView(date: Date)
    case inputDiaryUpdateView(date: Date, viewType: ViewType)
    case resolutionView
    case resolutionUpdateView
    case retrospectiveView
    case wiseSayingView(emotions: [String])
    case wiseSayingUpdateView(emotions: [String])
    case streakView
}

