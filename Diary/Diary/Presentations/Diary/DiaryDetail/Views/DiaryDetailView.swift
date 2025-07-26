//
//  DiaryDetailView.swift
//  Diary
//
//  Created by jinhyeokKim on 7/17/25.
//

import Foundation

struct DiaryEntry: Identifiable {
  let id = UUID()
  let date: Date
  let content: String
  let quote: String
  let vow: String
  let reflection: String
}
