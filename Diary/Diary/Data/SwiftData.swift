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
class ChallengeModel {
    
    var createDate: String // ID
    var diaryContent: String
    var wiseSaying: String
    var retrospective: String
    var resolution: String
    var summary: String
    
    
    init(createDate: String, diaryContent: String, wiseSaying: String, retrospective: String, resolution: String, summary: String) {
        self.createDate = createDate
        self.diaryContent = diaryContent
        self.wiseSaying = wiseSaying
        self.retrospective = retrospective
        self.resolution = resolution
        self.summary = summary
    }
    
}
