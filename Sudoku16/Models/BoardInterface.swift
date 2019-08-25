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
        var previous = -1
        for current in allForCell(index).sorted() {
            if current != previous && current != index {
                let value = cells[current].value
                if value != 0 { new16[value] = false }
                previous = current
            }
        }
        cells[index].canBe = new16
    }

    // Recalculate all canBe's and reset all highlights
    func reCalcAll() {
        sendNotifications(false)
        for current in cells.indices where cells[current].value == 0 {
            canBeRecalc(current)
            cells[current].reHighlight(true)
            cells[current].sendNotification()     // trigger redraw
        }
        only1CheckGlobal()
        sendNotifications(true)
    }

    // Set or reset a cell
    // Setting with a 0 is a reset
    @discardableResult
    func set(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        let ret = setOne(index, value, updateCanBe: updateCanBe)
        autofillUnqueue(.auto)
        return ret
    }

    // Highlight the current cell and all those on rows columns and squares
    func highlight(_ index: Int, _ value: Int, _ row: Bool, _ column: Bool, _ square: Bool) {
        var cellIndices: [Int] = []
        let hi: CellHighlight = (cells[index].highlight[value] != .user) ? .user : .low

        if row { cellIndices += rowForCell(index) }
        if column { cellIndices += columnForCell(index) }
        if square { cellIndices += squareForCell(index) }

        for current in cellIndices {
            cells[current].highlight[value] = hi
            cells[current].sendNotification()     // trigger redraw
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
        if candidates.isEmpty { return }
        let index = candidates[Int.random(in: candidates.indices)] // random cell
        let value = solution[index]
        setOne(index, value)
        cells[index].highlight[Cell.valueHighlight] = .hint
        hintCount.value += 1 + autofillUnqueue(.hint)
    }

    // generate a new board with a random solution
    static var random: Board {
        let board = Board()
        board.renew()
        return board
    }
}
