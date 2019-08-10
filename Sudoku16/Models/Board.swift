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

let squareOffsets = [ 0, 1, 2, 3, 16, 17, 18, 19, 32, 33, 34, 35, 48, 49, 50, 51 ]

func columnForCell(_ i: Int) -> Int {
    return i & 15
}

func cellInColumn(_ col: Int, _ i: Int) -> Int {
    return col | (i << 4)
}

func rowForCell(_ i: Int) -> Int {
    return i >> 4
}

func cellInRow(_ row: Int, _ i: Int) -> Int {
    return (row << 4) | i
}

func squareForCell(_ i: Int) -> Int {
    let col = columnForCell(i)
    let row = rowForCell(i)
    return (row & 0x0c) | (col >> 2)
}

func cellInSquare(_ sqr: Int, _ i: Int) -> Int {
    return (sqr << 2) | squareOffsets[i]
}

struct Board {
    var cells: [Cell] = Array(repeating: Cell(), count: 256)
}
