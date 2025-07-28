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
            return "chevron.left"
        case .next:
            return "chevron.right"
        case .none:
            return ""
        }
    }
}
