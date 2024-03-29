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

// return the column containing the cell
func columnForCell(_ i: Int) -> [Int] {
    let cell1 = i & 15
    var ret: [Int] = []
    for j in stride(from: cell1, to: cell1 + 256, by: 16) { ret.append(j) }
    return ret
}

// return the cells in column number
func cellsForColumn(_ col: Int) -> [Int] {
    return columnForCell(col)
}

// return the cells in the row containing the cell
func rowForCell(_ i: Int) -> [Int] {
    let cell1 = i & ~15
    var ret: [Int] = []
    for j in cell1...(cell1 + 15) { ret.append(j) }
    return ret
}

// return a list of the cells in row number
func cellsForRow(_ row: Int) -> [Int] {
    return rowForCell(row << 4)
}

// return a list of the cells in the square containing the cell
func squareForCell(_ i: Int) -> [Int] {
    let cell1 = i & 0xcc
    var ret: [Int] = []
    for j in squareOffsets { ret.append(cell1 + j) }
    return ret
}

// return a list of the cells in a square
func cellsForSquare(_ sqr: Int) -> [Int] {
    let sqrRow = sqr >> 2
    let sqrCol = sqr & 3
    return squareForCell(sqrRow << 4 | sqrCol << 2)
}

func allForCell(_ i: Int) -> [Int] {
    return columnForCell(i) + rowForCell(i) + squareForCell(i)
}

fileprivate let blueHue = 0.60
fileprivate let yellowHue = 0.15
fileprivate let dark = 0.7
fileprivate let light = 1.0

fileprivate let blueDark = Color(hue: blueHue, saturation: 0.1, brightness: dark)
fileprivate let blueDarkSelected = Color(hue: blueHue, saturation: 0.5, brightness: dark)
fileprivate let blueLight = Color(hue: blueHue, saturation: 0.1, brightness: light)
fileprivate let blueLightSelected = Color(hue: blueHue, saturation: 0.5, brightness: light)
fileprivate let yellowDark = Color(hue: yellowHue, saturation: 0.1, brightness: dark)
fileprivate let yellowDarkSelected = Color(hue: yellowHue, saturation: 0.9, brightness: dark)
fileprivate let yellowLight = Color(hue: yellowHue, saturation: 0.1, brightness: light)
fileprivate let yellowLightSelected = Color(hue: yellowHue, saturation: 0.9, brightness: light)

fileprivate let yellowColors = [ yellowLight, yellowDark, yellowLightSelected, yellowDarkSelected ]
fileprivate let blueColors = [ blueLight, blueDark, blueLightSelected, blueDarkSelected ]

func squareColor(_ index: Int, selected: Int = -1, scheme: ColorScheme = .light) -> Color {
    var colorIndex = 0
    if scheme == .dark { colorIndex += 1 }
    if index == selected { colorIndex += 2 }
    switch index & 0x4c {
    case 0, 8, 68, 76:
        return yellowColors[ colorIndex ]
    case 4, 12, 64, 72:
        return blueColors[ colorIndex ]
    default: return Color.clear
    }
}

class Board {
    // User Settings
    static let settings = UserSettings()

    var autofill: Bool { Self.settings.autofill }
    var initiallySolved: Int { Int(Self.settings.initiallySolved.rounded()) }
    var showWrongValues: Bool { Self.settings.showWrongValues }
    // Statistics
    var statErrors: Int {
        get { Self.settings.statErrors }
        set { Self.settings.statErrors = newValue }
    }
    var statHints: Int {
        get { Self.settings.statHints }
        set { Self.settings.statHints = newValue }
    }

    var statSolved: Int {
        get { Self.settings.statSolved }
        set { Self.settings.statSolved = newValue }
    }

    var solution: [Int] = Array(repeating: 0, count: 256)
    var cells: [Cell] = []
    var erred = PublishingInt(0)
    var hintCount = PublishingInt(0)
    var unsolved = PublishingInt(0)
    var autofillQueue: [Int] = []
    var autofilled = PublishingInt(0)

    init() {
        for _ in 0...255 { self.cells.append(Cell()) }
    }

    func updateStats() {
        statErrors += erred.value
        statHints += hintCount.value
        statSolved += 1
    }

    func clear() {
        _ = cells.map { $0.clear() }
        autofilled.value = 0
        erred.value = 0
        hintCount.value = 0
        unsolved.value = 256
    }

    // Turn publishing on or off for all cells
    func sendNotifications(_ send: Bool) { _ = cells.map { $0.sendNotifications(send) } }

    // Check for any number that has only one candidate
    func only1Check(for checkList: [Int]) -> Bool {
        var ret = false
        let cellList = checkList.map { cells[$0] }.filter { $0.value == 0}
        if cellList.isEmpty { return false }
        for value in Set16.range {
            var only1 = false
            var mark: Cell? = nil
            for cell in cellList where cell.canBe[value] {
                if !only1 {
                    only1 = true
                    mark = cell
                } else {
                    // two or more hits
                    only1 = false
                    break
                }
            }
            if only1 {
                mark?.highlight[value] = .only1
                mark?.sendNotification()
                ret = true
            }
        }

        return ret
    }

    // Run only1Check over column, row and square
    @discardableResult
    func only1CheckAll(for index: Int) -> Bool {
        var ret = false

        if only1Check(for: columnForCell(index)) { ret = true }
        if only1Check(for: rowForCell(index)) { ret = true }
        if only1Check(for: squareForCell(index)) { ret = true }

        return ret
    }

    // Run only1Check over all columns, rows and squares
    @discardableResult
    func only1CheckGlobal() -> Bool {
        var ret = false

        for index in 0...15 {
            if only1Check(for: cellsForColumn(index)) { ret = true }
            if only1Check(for: cellsForRow(index)) { ret = true }
            if only1Check(for: cellsForRow(index)) { ret = true }
        }
        return ret
    }

    // Set all the canBe's in rows, columns or squares, ignoring duplicates
    @discardableResult
    func canBeSetAll(_ index: Int, _ value: Int, _ setTo: Bool) -> Bool {
        var ret = true
        var j = -1
        for i in allForCell(index).sorted() {
            if i != j && i != index {
                let cell = cells[i]
                cell.canBe[value] = setTo
                if cell.canBe.isEmpty { ret = false }
                cell.reHighlight()
                if autofill && cell.canBe.count == 1 && cell.value == 0 { autofillQueue.append(i) }
                j = i
            }
        }
        return ret
    }

    // Set or reset a cell
    // Setting with a 0 is a reset
    @discardableResult
    func setOne(_ index: Int, _ value: Int, updateCanBe: Bool = true) -> Bool {
        var ret = true
        let cell = self.cells[ index ]
        if cell.value == value { return true }
        if Set16.range.contains(value) {
            let err = solution[index] != value
            if err { erred.value += 1 }
            cell.value = value
            unsolved.value -= 1
            cell.highlight[Cell.valueHighlight] =
                (showWrongValues && err) ? .wrong : .low
            cell.highlight[Cell.borderHighlight] = .low
            // Set canBe to only the set value
            cell.canBe = Set16[value]
            // Don't update canBe's if not the right solution
            if updateCanBe && solution[index] == value {
                if !canBeSetAll(index, value, false) { ret = false }
                only1CheckAll(for: index)
            }
        } else {
            if Set16.range.contains(cell.value) {
                // Don't update canBe's if not the right solution
                if solution[index] == cell.value { canBeSetAll(index, cell.value, true) }
                unsolved.value += 1
            }
            cell.value = 0
            canBeRecalc(index)
            cell.highlight[Cell.valueHighlight] = .low
        }
        cell.reHighlight()

        if unsolved.value == 0 { updateStats() }

        return ret
    }

    // Copy all or a part of the solution
    func copySolution(_ count: Int = 256) {
        sendNotifications(false)
        clear()
        let indices = Array(0...255).shuffled().prefix(count)
        let update = (count < 256)
        for i in indices {
            set(i, solution[i], updateCanBe: update)
        }
        sendNotifications(true)
    }

    // Take cells from the queue and solve them, return the number of cells autofilled
    @discardableResult
    func autofillUnqueue(_ hi: CellHighlight) -> Int {
        var count = 0

        while !autofillQueue.isEmpty {
            let i = autofillQueue.removeLast()
            let v = solution[i]
            setOne(i, v)
            cells[i].highlight[Cell.valueHighlight] = hi
            count += 1
        }
        autofilled.value += count

        return count
    }
}
