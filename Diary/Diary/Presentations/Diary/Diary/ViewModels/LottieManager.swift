//
//  LottieManager.swift
//  Diary
//
//  Created by jinhyeokKim on 7/26/25.
//

import Foundation
import Combine

@MainActor
final class LottieManager: ObservableObject {
    @Published var shouldPlayLottie: Bool = false
}
