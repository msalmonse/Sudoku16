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
    
    var autofill : Bool { Self.settings.autofill }
    var initiallySolved: Int { Int(Self.settings.initiallySolved.rounded()) }
    var showWrongValues : Bool { Self.settings.showWrongValues }

    var solution: [Int] = Array(repeating: 0, count: 256)
    var cells: [Cell] = []
    var hintCount = PublishingInt(0)
    var unsolved = PublishingInt(0)
    var autofillQueue: [Int] = []
    
    init() {
        for _ in 0...255 { self.cells.append(Cell()) }
    }
    
    func clear() {
        _ = cells.map{ $0.clear() }
        unsolved.value = 0
        hintCount.value = 0
    }

    func sendNotifications(_ send: Bool) { _ = cells.map{ $0.sendNotifications(send)} }
    
    // Set all the canBe's in rows, columns or squares, ignoring duplicates
    func canBeSetAll(_ index: Int, _ value: Int, _ set: Bool) -> Bool {
        var ret = true
        var j = -1
        for i in allForCell(index).sorted() {
            if (i != j && i != index) {
                let cell = cells[i]
                _ = cell.canBe.set(value, set)
                if cell.canBe.isEmpty { ret = false }
                if autofill && cell.canBe.count == 1 && cell.value == 0 { autofillQueue.append(i) }
                j = i
            }
        }
        return ret
    }
    
    // Set or reset a cell
    // Setting with a 0 is a reset
    func setOne(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        var ret = true
        let cell = self.cells[ index ]
        if cell.value == value { return true }
        if range16.contains(value) {
            cell.value = value
            unsolved.value -= 1
            cell.highlight[Cell.valueIndex] =
                (showWrongValues && solution[index] != value) ? .wrong : .none
            cell.highlight[Cell.borderIndex] = .none
            cell.canBe.setOnly(value)
            // Don't update canBe's if not the right solution
            if updateCanBe && solution[index] == value {
                if !canBeSetAll(index, value, false) { ret = false }
            }
        }
        else {
            if range16.contains(cell.value) {
                // Don't update canBe's if not the right solution
                if solution[index] == cell.value { _ = canBeSetAll(index, cell.value, true) }
                unsolved.value += 1
            }
            cell.value = 0
            canBeRecalc(index)
            cell.highlight[Cell.valueIndex] = .none
        }
        
        return ret
    }

    // Take cells from the queue and solve them
    func autofillUnqueue(_ hi: CellHighlight) -> Int {
        var count = 0
        
        while !autofillQueue.isEmpty {
            let i = autofillQueue.removeLast()
            let v = solution[i]
            _ = setOne(i, v)
            cells[i].highlight[Cell.valueIndex] = hi
            count += 1
        }
        return count
    }
}
