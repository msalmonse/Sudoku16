//
//  Board.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import SwiftUI

/// Helper functions to calculate cell position

// cells 0...15 are row 0
// cells 0,16,32... are column 0
// cells 0...3,16...19,32...35,48...51 are square 0

fileprivate let squareOffsets = [
    0, 1, 2, 3, 16, 17, 18, 19, 32, 33, 34, 35, 48, 49, 50, 51
]

func columnForCell(_ i: Int) -> [Int] {
    let cell1 = i & 15
    var ret: [Int] = []
    for j in stride(from: cell1, to: cell1 + 256, by: 16) { ret.append(j) }
    return ret
}

func cellInColumn(_ col: Int, _ i: Int) -> Int {
    return col | (i << 4)
}

func rowForCell(_ i: Int) -> [Int] {
    let cell1 = i & ~15
    var ret: [Int] = []
    for j in cell1...(cell1 + 15) { ret.append(j) }
    return ret
}

func cellInRow(_ row: Int, _ i: Int) -> Int {
    return (row << 4) | i
}

func squareForCell(_ i: Int) -> [Int] {
    let cell1 = i & 0xcc
    var ret: [Int] = []
    for j in squareOffsets { ret.append(cell1 + j) }
    return ret
}

func allForCell(_ i: Int) -> [Int] {
    return columnForCell(i) + rowForCell(i) + squareForCell(i)
}

func cellInSquare(_ sqr: Int, _ i: Int) -> Int {
    return (sqr << 2) | squareOffsets[i]
}

func squareColor(cell: Int) -> Color {
    switch cell & 0x4c {
    case 0, 8, 68, 76:
        return Color.yellow.opacity(0.2)
    case 4, 12, 64, 72:
        return Color.blue.opacity(0.1)
    default: return Color.clear
    }
}

class Board {
    // User Settings
    static let settings = UserSettings()
    
    var showWrongValues : Bool { Self.settings.showWrongValues }
    var initiallySolved: Int { Int(Self.settings.initiallySolved.rounded()) }

    var solution: [Int] = Array(repeating: 0, count: 256)
    var cells: [Cell] = []
    var unsolved = PublishingInt(0)
    
    init() {
        for _ in 0...255 { self.cells.append(Cell()) }
    }
    
    func clear() { _ = cells.map{ $0.clear() } }

    func sendNotifications(_ send: Bool) { _ = cells.map{ $0.sendNotifications(send)} }
    
    // Set all the canBe's in rows, columns or squares, ignoring duplicates
    func canBeSetAll(_ index: Int, _ value: Int, _ set: Bool) -> Bool {
        var ret = true
        var j = -1
        for i in allForCell(index).sorted() {
            if (i != j && i != index) {
                _ = cells[i].canBe.set(value, set)
                if cells[i].canBe.isEmpty { ret = false }
                j = i
            }
        }
        return ret
    }
    
}
