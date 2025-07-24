//
//  Font.swift
//  Diary
//
//  Created by jinhyeokKim on 7/14/25.
//

import Foundation
import SwiftUI

extension Font {
    static var title1: Font {
        .system(size: 20, weight: .medium)
    }
    static var title1Emphasized: Font {
        .system(size: 20, weight: .bold)
    }
    static var title2: Font {
        .system(size: 17, weight: .medium)
    }
    static var body1: Font {
        .system(size: 22, weight: .regular)
    }
    static var body2Regular: Font {
        .system(size: 17, weight: .regular)
    }
    static var body2Emphasized: Font {
        .system(size: 17, weight: .semibold)
    }
    static var caption1Emphasized: Font {
        .system(size:13, weight: .semibold)
    }
}

