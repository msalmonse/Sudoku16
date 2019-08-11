//
//  Board.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

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

class Board {
    var cells: [Cell] = []
    
    init() {
        for _ in 0...255 { self.cells.append(Cell()) }
    }

    private func canBeSet(_ index: Int, _ value: Int, _ set: Bool) {
        var j = -1
        for i in allForCell(index).sorted() {
            if (i != j && i != index) {
                _ = cells[i].canBe.set(value, set)
                j = i
            }
        }
    }

    func set(_ index: Int, _ value: Int) {
        let cell = self.cells[ index ]
        if !range16.contains(cell.value) {
            cell.value = value
            canBeSet(index, value, false)
        }
    }

    static var random: Board {
        let board = Board()
        for _ in 1...32 {
            board.set(Int.random(in: 0...255), Int.random(in: 1...16))
        }
        return board
    }
}
