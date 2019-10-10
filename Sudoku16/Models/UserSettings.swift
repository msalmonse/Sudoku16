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
import UserDefaults

final class UserSettings: ObservableObject, Identifiable {
    let id = UUID()
    let objectWillChange = ObservableObjectPublisher()

    @UserDefault("ShowWrongValues", defaultValue: true)
    var showWrongValues: Bool {
        willSet { objectWillChange.send() }
    }

    @UserDefault("InitiallySolved", defaultValue: 128.0)
    var initiallySolved: Double {
        willSet { objectWillChange.send() }
    }

    @UserDefault("Autofilled", defaultValue: false)
    var autofill: Bool {
        willSet { objectWillChange.send() }
    }

    // Statistics

    // Number of puzzles solved
    @UserDefault("StatSolved", defaultValue: 0)
    var statSolved: Int {
        willSet { objectWillChange.send() }
    }

    // Number of errors
    @UserDefault("StatErrors", defaultValue: 0)
    var statErrors: Int {
        willSet { objectWillChange.send() }
    }

    // Number of hints given
    @UserDefault("StatHints", defaultValue: 0)
    var statHints: Int {
        willSet { objectWillChange.send() }
    }

    init() { return }
}
