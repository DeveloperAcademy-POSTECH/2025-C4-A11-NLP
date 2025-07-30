//
//  LottieType.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import Foundation

enum LottieType {
    case confettie
    case fire
    case loading
    
    var lottie: String {
        switch self {
        case .confettie: return "confettie"
        case .fire: return "fire"
        case .loading: return "loading"
        }
    }
}
