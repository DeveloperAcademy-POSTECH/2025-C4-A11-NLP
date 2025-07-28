//
//  SwiftData.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftData

// MARK: - 다이어리 SwiftData 모델
@Model
final class DiaryModelData {
    
    var createDate: Date // ID
    var diaryContent: String
    var wiseSaying: String
    var retrospective: String
    var resolution: String
    
    // 요약
    var diaryContentSummary: String
    var wiseSayingSummary: String
    var retrospectiveSummary: String
    var resolutionSummary: String
    
    
    init(
        createDate: Date,
        diaryContent: String,
        wiseSaying: String,
        retrospective: String,
        resolution: String,
        diaryContentSummary: String,
        wiseSayingSummary: String,
        retrospectiveSummary: String,
        resolutionSummary: String
    ) {
        self.createDate = createDate
        self.diaryContent = diaryContent
        self.wiseSaying = wiseSaying
        self.retrospective = retrospective
        self.resolution = resolution
        self.diaryContentSummary = diaryContentSummary
        self.wiseSayingSummary = wiseSayingSummary
        self.retrospectiveSummary = retrospectiveSummary
        self.resolutionSummary = resolutionSummary
    }
    
}
