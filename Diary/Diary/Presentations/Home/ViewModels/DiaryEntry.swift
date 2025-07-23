//
//  DiaryEntry.swift
//  Diary
//
//  Created by Yurim on 7/24/25.
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
