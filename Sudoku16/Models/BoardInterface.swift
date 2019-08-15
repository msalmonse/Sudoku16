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
    
    // Set or reset a cell
    // Setting with a 0 is a reset
    func set(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        var ret = true
        let cell = self.cells[ index ]
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
    
    // Highlight the current cell and all those on rows columns and squares
    func highlight(_ index: Int, _ value: Int, _ row: Bool, _ column: Bool, _ square: Bool) {
        var cellIndices: [Int] = []
        let hi: CellHighlight = (cells[index].highlight[value] != .user) ? .user : .none
        
        if row { cellIndices += rowForCell(index) }
        if column { cellIndices += columnForCell(index) }
        if square { cellIndices += squareForCell(index) }
        
        for i in cellIndices {
            cells[i].highlight[value] = hi
            cells[i].value = cells[i].value     // trigger redraw
        }
    }

    
    // Copy all or a part of the solution
    func solve(_ count: Int = 256) {
        sendNotifications(false)
        clear()
        let indices = Array(0...255).shuffled().prefix(count)
        let update = (count < 256)
        unsolved.value = 256
        for i in indices {
            _ = set(i, solution[i], updateCanBe: update)
        }
        sendNotifications(true)
    }

    // Clear out and start again
    func restart() { solve(initiallySolved) }

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
        _ = set(i, v)
        cells[i].highlight[Cell.valueIndex] = .hint
    }

    // generate a new board with a random solution
    static var random: Board {
        let board = Board()
        board.renew()
        return board
    }
}
