//
//  NavigationRouter.swift
//  Diary
//
//  Created by jinhyeokKim on 7/23/25.
//

import SwiftUI
import Combine

class NavigationRouter: ObservableObject, NavigationRoutable {
    
    @Published var destination: [NavigationDestination] = []
    
    func push(to view: NavigationDestination) { destination.append(view) }
    func pop() { _ = destination.popLast() }
    func popToRootView() { destination.removeAll() }
}

