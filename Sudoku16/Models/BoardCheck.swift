//
//  BoardCheck.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-12-16.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

extension Board {
    // Check that a list of ints has 1...16 exctly once
    static func check(_ values: [Int]) -> Bool {
        var present = Set16.empty

        if values.count != 16 { return false }

        for val in values {
            // set return the previous value, if true then we have a double value
            if present.set(val, true) { return false }
        }

        return true
    }

    // check that a column contains each value once
    func colCheck(_ col: Int) -> Bool {
        let values = cellsForColumn(col)
        return Board.check(values)
    }

    // check that a row contains each value once
    func rowCheck(_ row: Int) -> Bool {
        let values = cellsForRow(row)
        return Board.check(values)
    }

    // check that a square contains each value once
    func sqrCheck(_ sqr: Int) -> Bool {
        let values = cellsForSquare(sqr)
        return Board.check(values)
    }
}
