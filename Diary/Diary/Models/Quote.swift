//
//  WiseSayingData.swift
//  Diary
//
//  Created by jinhyeokKim on 7/24/25.
//

import Foundation

struct Quote: Codable {
    let respondent: String
    let quote: String
    let quoteSource: String?
    let label: String
    
    enum CodingKeys: String, CodingKey {
        case respondent = "응답자"
        case quote = "명언"
        case quoteSource = "명언 출처"
        case label = "레이블"
    }
}
