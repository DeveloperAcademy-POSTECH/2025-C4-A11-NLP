//
//  HomeViewModel.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftUI
import Combine


class DiaryStore: ObservableObject {
  @Published var entries: [DiaryEntry] = [
    DiaryEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())! /*date: Date()*/, content: "내일 시험인데 아직도 책을 안 펼쳤다.", quote: "늦었다고 시작할때가 진짜 너무 늦었다. - 박명수", vow: "지금이라도 시작해야겠다.", reflection: "-"),
    DiaryEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, content: "명륜진사갈비는 어떤 맛일까.", quote: "먹고 죽은 귀신이 때깔도 곱다.", vow: "체력 보강을 위해 고기를 매주 한번씩 먹자.", reflection: "고기 값 너무 비싸다.. (소)고기 말고 생선이라도 먹자")
  ]
  
  func diary(for date: Date) -> DiaryEntry? {
    entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
  }
}
