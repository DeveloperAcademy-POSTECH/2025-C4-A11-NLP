//
//  NavigationRoutable.swift
//  Diary
//
//  Created by jinhyeokKim on 7/23/25.
//

import Foundation

protocol NavigationRoutable {
    
    var destination: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
    
}

