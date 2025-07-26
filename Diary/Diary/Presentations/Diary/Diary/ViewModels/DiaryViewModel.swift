//
//  DiaryViewModel.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import Foundation

@Observable
final class DiaryViewModel {
    
    var diary: DiaryModel = .init(createDate: "", diaryContent: "", wiseSaying: "", retrospective: "", resolution: "", summary: "")
    
    var shouldPlayLottie: Bool = false
    
}

