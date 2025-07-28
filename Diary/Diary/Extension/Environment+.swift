//
//  Environment+.swift
//  Diary
//
//  Created by jinhyeokKim on 7/25/25.
//

import SwiftUI


private struct DiaryViewModelKey: EnvironmentKey {
    static let defaultValue = DiaryViewModel()
}


extension EnvironmentValues {
    var diaryVM: DiaryViewModel {
        get { self[DiaryViewModelKey.self] }
        set { self[DiaryViewModelKey.self] = newValue }
    }
}
