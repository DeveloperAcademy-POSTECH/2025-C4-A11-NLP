//
//  CalenderContentButtonType.swift
//  Diary
//
//  Created by jinhyeokKim on 7/24/25.
//

import Foundation

enum CalenderContentButtonType {
    case previous
    case next
    case none
    
    var image: String {
        switch self {
        case .previous:
            return "arrow.left"
        case .next:
            return "arrow.right"
        case .none:
            return ""
        }
    }
}
