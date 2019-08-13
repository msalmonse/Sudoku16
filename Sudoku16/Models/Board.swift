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
    var solution: [Int] = Array(repeating: 0, count: 256)
    var cells: [Cell] = []
    
    init() {
        for _ in 0...255 { self.cells.append(Cell()) }
    }
    
    // Copy all or a part of the solution
    func solve(_ count: Int = 256) {
        let indices = Array(0...255).shuffled().prefix(count)
        let update = (count < 256)
        for i in indices {
            _ = set(i, solution[i], updateCanBe: update)
        }
    }
    
    // Set all the canBe's in rows, columns or squares, ignoring duplicates
    private func canBeSetAll(_ index: Int, _ value: Int, _ set: Bool) -> Bool {
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
    
    // Recalculate the canBe based on all values
    func canBeRecalc(_ index: Int) {
        let cell = cells[index]
        cell.canBe = all16
        var j = -1
        for i in allForCell(index).sorted() {
            if (i != j && i != index) {
                let value = cells[i].value
                if value != 0 { _ = cell.canBe.set(value, false) }
                j = i
            }
        }
    }
    
    func clear() {
        for i in cells.indices { cells[i].clear() }
    }
    
    func restart() {
        clear()
        solve(128)
    }

    func set(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        var ret = true
        let cell = self.cells[ index ]
        if range16.contains(value) {
            cell.value = value
            cell.highlight[Cell.valueIndex] = (solution[index] == value) ? .none : .wrong
            cell.canBe.setOnly(value)
            if updateCanBe {
                if !canBeSetAll(index, value, false) { ret = false }
            }
        }
        else {
            if range16.contains(cell.value) { _ = canBeSetAll(index, cell.value, true) }
            cell.value = 0
            canBeRecalc(index)
            cell.highlight[Cell.valueIndex] = .none
        }
        
        return ret
    }

    static var random: Board {
        let board = Board()
        board.randomSolve()
        board.solve(128)
        return board
    }
}
