//
//  SentimentViewModel.swift
//  Diary
//
//  Created by JiJooMaeng on 7/24/25.
//


import Foundation
import NaturalLanguage
import CoreML

@Observable
class SentimentViewModel
 {
    var model: NLModel?

    init() {
        loadModel()
    }

    private func loadModel() {
        if let sentimentModel = try? SentimentClassifier(configuration: MLModelConfiguration()).model,
           let nlModel = try? NLModel(mlModel: sentimentModel) {
            self.model = nlModel
        } else {
            print("⚠️ 모델 로딩 실패")
        }
    }

    /// 확률이 높은 순서대로 상위 N개 감정 반환
    func predictTopSentiments(for text: String, count: Int = 3) -> [(String, Double)] {
        guard let hypotheses = model?.predictedLabelHypotheses(for: text, maximumCount: 10) else {
            return [("분류 실패", 0.0)]
        }

        // 확률 높은 순으로 정렬하고 상위 N개 선택
        let sorted = hypotheses.sorted { $0.value > $1.value }.prefix(count)
        
        // 퍼센트로 변환
        return sorted.map { (label, score) in
            (label, round(score * 1000) / 10)  // 소수점 한자리 (ex. 86.7%)
        }
    }
}



