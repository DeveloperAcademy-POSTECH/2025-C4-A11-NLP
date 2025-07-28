//
//  DiaryViewModel.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import Foundation
import SwiftData
import FoundationModels

@Observable
final class DiaryViewModel {
    private let model = SystemLanguageModel.default
    var diary: DiaryModel = .init(
        diaryContent: "",
        wiseSaying: "",
        retrospective: "",
        resolution: "",
        diaryContentSummary: "",
        wiseSayingSummary: "",
        retrospectiveSummary: "",
        resolutionSummary: ""
    )
    
    init() {
        let todayStartOfDay = Calendar.current.startOfDay(for: Date())
        self.diary.createDate = todayStartOfDay
    }
    
    var shouldPlayLottie: Bool = false
    
    func resetDiary() {
        self.diary = .init(
            diaryContent: "",
            wiseSaying: "",
            retrospective: "",
            resolution: "",
            diaryContentSummary: "",
            wiseSayingSummary: "",
            retrospectiveSummary: "",
            resolutionSummary: ""
        )
    }
    
    func summarize(_ text: String) async throws -> String {
        let prompt = """
               \(text)에 대한 내용을 최대한 짧게 한 줄로 요약해줘.
               """
        let session = LanguageModelSession()
        let response = try await session.respond(to: prompt)
        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
