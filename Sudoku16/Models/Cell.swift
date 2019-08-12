//
//  Cell.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import SwiftUI

enum CellHighlight {
    case none   // no highlighting
    case canBe1 // only one possibility
    case canBe2 // two possibilities
    
    var color: Color {
        switch self {
        case .none:   return .primary
        case .canBe1: return .green
        case .canBe2: return .orange
        }
    }
}
/// Details of each cell

class Cell: ObservableObject, Identifiable {
    let id = UUID()
    @Published
    var value: Int = 0
    @Published
    var canBe = all16
    var highlight: [CellHighlight] = Array(repeating: .none, count: 17)
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
