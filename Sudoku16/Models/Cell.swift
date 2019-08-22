//
//  Cell.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

/// The highlight colour of a cell

enum CellHighlight {
    case low    // no highlighting
    case alert  // something wrong
    case auto   // autofilled cell
    case canBe0 // no possible values
    case canBe1 // only one possibility
    case canBe2 // two possibilities
    case hint   // result of hint
    case user   // user highlighted
    case wrong  // doesn't match solution

    var color: Color {
        switch self {
        case .alert:    return .red
        case .auto:     return .secondary
        case .canBe0:   return .red
        case .canBe1:   return .green
        case .canBe2:   return .orange
        case .hint:     return .green
        case .low:      return .primary
        case .user:     return .blue
        case .wrong:    return .red
        }
    }

    var sticky: Bool {
        switch self {
        case .alert:    return true
        case .auto:     return true
        case .canBe0:   return false
        case .canBe1:   return false
        case .canBe2:   return false
        case .hint:     return true
        case .low:      return false
        case .user:     return true
        case .wrong:    return true
        }

    }
}

// Send notifications or not

fileprivate enum Notify {
    case send   // send notification
    case quiet  // no notifications
    case needto // send a notification next time it's allowed
}

/// Details of each cell

class Cell: ObservableObject, Identifiable {
    // Indices for highlight
    static let valueHighlight = 0
    // 1...16 for canBe values
    static let borderHighlight = 17
    static let highlightCount = 18

    var objectWillChange = ObservableObjectPublisher()
    fileprivate var notify = Notify.send
    func sendNotification() {
        switch notify {
        case .send: objectWillChange.send()
        case .quiet: notify = .needto
        case .needto: break
        }
    }

    let id = UUID()
    var value: Int = 0 { willSet { sendNotification() } }
    var canBe = all16 { willSet { if canBe != newValue { sendNotification() } } }
    var highlight: [CellHighlight] = Array(repeating: .low, count: highlightCount)

    var backgroundColor: Color {
        let hi = highlight[Cell.borderHighlight]
        return (hi == .low) ? .clear : hi.color.opacity(0.4)
    }
    var borderColor: Color { highlight[Cell.borderHighlight].color }
    var valueColor: Color { highlight[Cell.valueHighlight].color }

    func clear() {
        value = 0
        canBe = all16
        for i in highlight.indices { highlight[i] = .low }
    }

    func sendNotifications(_ send: Bool) {
        switch (notify, send) {
        case (.needto, true):   notify = .send; sendNotification()
        case (.needto, false):  break
        case (.send, true):     break
        case (.send, false):    notify = .quiet
        case (.quiet, true):    notify = .send
        case (.quiet, false):   break
        }
    }

    /// Calculate the highlights for a cell
    func reHighlight(_ unstick: Bool = false) {
        var hi: CellHighlight = .low
        switch canBe.count {
        case 0: hi = .canBe0
        case 1: hi = .canBe1
        case 2: hi = .canBe2
        default: break
        }

        for i in range16 {
           if unstick || !highlight[i].sticky {
               highlight[i] = canBe[i] ? hi : .low
           }
        }

        if !highlight[Cell.borderHighlight].sticky {
           highlight[Cell.borderHighlight] = (hi == .canBe0) ? hi : .low
        }
    }

    /// Return the name associated with a value
    var name: String { return nameForValue(value) }
}

// Convert a value to an image name

// swiftlint:disable cyclomatic_complexity
func nameForValue(_ i: Int) -> String {
    switch i {
    case  1: return  "1.square"
    case  2: return  "2.square"
    case  3: return  "3.square"
    case  4: return  "4.square"
    case  5: return  "5.square"
    case  6: return  "6.square"
    case  7: return  "7.square"
    case  8: return  "8.square"
    case  9: return  "9.square"
    case 10: return "10.square"
    case 11: return "11.square"
    case 12: return "12.square"
    case 13: return "13.square"
    case 14: return "14.square"
    case 15: return "15.square"
    case 16: return "16.square"
    default: return "square"
    }
}
