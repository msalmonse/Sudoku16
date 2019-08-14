//
//  Cell.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import SwiftUI

/// The highlight colour of a cell

enum CellHighlight {
    case none   // no highlighting
    case alert  // something wrong
    case canBe0 // no possible values
    case canBe1 // only one possibility
    case canBe2 // two possibilities
    case user   // user highlighted
    case wrong  // doesn't match solution
    
    var color: Color {
        switch self {
        case .none:     return .primary
        case .alert:    return .red
        case .canBe0:   return .red
        case .canBe1:   return .green
        case .canBe2:   return .orange
        case .user:     return .blue
        case .wrong:    return .red
        }
    }
}

/// Details of each cell

class Cell: ObservableObject, Identifiable {
    // Indices for highlight
    static let valueIndex = 0
    // 1...16 for canBe values
    static let borderIndex = 17

    let id = UUID()
    @Published
    var value: Int = 0
    @Published
    var canBe = all16
    var highlight: [CellHighlight] = Array(repeating: .none, count: 18)
    
    var backgroundColor: Color {
        let hi = highlight[Cell.borderIndex]
        return (hi == .none) ? .clear : hi.color.opacity(0.4)
    }
    var borderColor: Color { highlight[Cell.borderIndex].color }

    func clear() {
        value = 0
        canBe = all16
        for i in highlight.indices { highlight[i] = .none }
    }
}

// Convert a value to an image name

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
