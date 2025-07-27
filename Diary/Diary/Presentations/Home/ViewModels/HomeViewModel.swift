//
//  HomeViewModel.swift
//  Diary
//
//  Created by Yurim on 7/24/25.
//

import Foundation
import SwiftUI
import Combine

class DiaryStore: ObservableObject {
  @Published var entries: [DiaryEntry]

  init() {
    let today = Date()
    let calendar = Calendar.current

    self.entries = [
      DiaryEntry(
        date: calendar.date(byAdding: .day, value: -1, to: today)!,
        content: "내일 시험인데 아직도 책을 안 펼쳤다.",
        quote: "늦었다고 시작할때가 진짜 너무 늦었다. - 박명수",
        vow: "지금이라도 시작해야겠다.",
        reflection: "-"
      ),
      DiaryEntry(
        date: calendar.date(byAdding: .day, value: 0, to: today)!,
        content: "명륜진사갈비는 어떤 맛일까.",
        quote: "먹고 죽은 귀신이 때깔도 곱다.",
        vow: "체력 보강을 위해 고기를 매주 한번씩 먹자.",
        reflection: "고기 값 너무 비싸다.. (소)고기 말고 생선이라도 먹자"
      )
    ]
  }

  func diary(for date: Date) -> DiaryEntry? {
    entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
  }
    
    // 연속 작성한 일기 일수
      var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let writtenDates: Set<Date> = Set(entries.map { calendar.startOfDay(for: $0.date) })

        var streak = 0
        var current = today

        while writtenDates.contains(current) {
          streak += 1
          guard let previous = calendar.date(byAdding: .day, value: -1, to: current) else { break }
          current = previous
        }

        return streak
      }
}
