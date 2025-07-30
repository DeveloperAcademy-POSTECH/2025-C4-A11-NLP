//
//  Font.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftUI

extension Font {
    static let ppAcma26: Font = .custom("PPAcma-Semibold", size: 26)
    static let ppAcma70: Font = .custom("PPAcma-Semibold", size: 70)
    
    static var titleOne: Font {
        .system(size: 20, weight: .medium)
    }
    static var title1Emphasized: Font {
        .system(size: 20, weight: .bold)
    }
    static var titleTwo: Font {
        .system(size: 18, weight: .medium)
    }
    static var body1Regular: Font {
        .system(size: 17, weight: .regular)
    }
    static var body1Semibold: Font {
        .system(size: 17, weight: .semibold)
    }
    static var caption1: Font {
        .system(size:16, weight: .semibold)
    }
    static var caption2Regular: Font {
        .system(size:14, weight: .regular)
    }
    static var caption2Emphasized: Font {
        .system(size:14, weight: .semibold)
    }
    static var caption3: Font {
        .system(size:13, weight: .regular)
    }
}

