//
//  BoardInterface.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

extension Board {

    // Recalculate the canBe based on all values
    func canBeRecalc(_ index: Int) {
        var new16 = all16
        var j = -1
        for i in allForCell(index).sorted() {
            if (i != j && i != index) {
                let value = cells[i].value
                if value != 0 { _ = new16.set(value, false) }
                j = i
            }
        }
        cells[index].canBe = new16
    }
    
    // Recalculate all canBe's and reset all highlights
    func reCalcAll() {
        sendNotifications(false)
        for i in cells.indices {
            canBeRecalc(i)
            cells[i].reHighlight(true)
            cells[i].sendNotification()     // trigger redraw
        }
        sendNotifications(true)
    }
    
    // Set or reset a cell
    // Setting with a 0 is a reset
    func set(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        let ret = setOne(index, value, updateCanBe: updateCanBe)
        _ = autofillUnqueue(.auto)
        return ret
    }
    
    // Highlight the current cell and all those on rows columns and squares
    func highlight(_ index: Int, _ value: Int, _ row: Bool, _ column: Bool, _ square: Bool) {
        var cellIndices: [Int] = []
        let hi: CellHighlight = (cells[index].highlight[value] != .user) ? .user : .none
        
        if row { cellIndices += rowForCell(index) }
        if column { cellIndices += columnForCell(index) }
        if square { cellIndices += squareForCell(index) }
        
        for i in cellIndices {
            cells[i].highlight[value] = hi
            cells[i].sendNotification()     // trigger redraw
        }
    }

    // Get hints until there are no unsolved cells
    func solve() {
        while unsolved.value > 0 { hint() }
    }

    // Clear out and start again
    func restart() { copySolution(initiallySolved) }

    // generate a new randon solution
    func renew() {
        randomizeSolution()
        restart()
    }

    // Give a hint: give a square the correct solution
    func hint() {
        let candidates = cells.indices.filter({ cells[$0].value == 0 })
        let i = candidates[Int.random(in: candidates.indices)] // random cell
        let v = solution[i]
        _ = setOne(i, v)
        cells[i].highlight[Cell.valueHighlight] = .hint
        hintCount.value += 1 + autofillUnqueue(.hint)
    }

    // generate a new board with a random solution
    static var random: Board {
        let board = Board()
        board.renew()
        return board
    }
}
