//
//  UserSettings.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-14.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class UserSettings: ObservableObject, Identifiable {
    let id = UUID()
    let objectWillChange = ObservableObjectPublisher()
    
    @UserDefault("ShowWrongValues", defaultValue: true)
    var showWrongValues : Bool {
        willSet { objectWillChange.send() }
    }
    
    @UserDefault("Difficulty", defaultValue: 128)
    var difficulty: Int {
        willSet { objectWillChange.send() }
    }
}
