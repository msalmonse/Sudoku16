//
//  Sudoku16Tests.swift
//  Sudoku16Tests
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import XCTest
@testable import Sudoku16

class Sudoku16Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSet16() {
        var test = Set16.all

        XCTAssertTrue(test.contains(1))
        XCTAssertTrue(test.contains(16))
        XCTAssertFalse(test.contains(0))
        XCTAssertFalse(test.contains(17))

        XCTAssertTrue(test.set(1, false))
        XCTAssertFalse(test.contains(1))
        XCTAssertEqual(test.count, 15)

        XCTAssertFalse(test.set(1, true))
        XCTAssertTrue(test.contains(1))
        XCTAssertEqual(test.count, 16)
        XCTAssertFalse(test.isEmpty)

        test = Set16.empty
        XCTAssertEqual(test.count, 0)
        XCTAssertTrue(test.isEmpty)

        _ = test.toggle(2)
        XCTAssertTrue(test.contains(2))
        XCTAssertTrue(test[2])
        _ = test.toggle(2)
        XCTAssertFalse(test.contains(2))
        XCTAssertFalse(test[2])
        XCTAssertTrue(test.isEmpty)

        test[4] = true
        XCTAssertTrue(test.contains(4))

        test = Set16[6]
        XCTAssertTrue(test.contains(6))
        XCTAssertFalse(test[2])
    }

    func testCols() {
        let testDict: [Int: [Int]] = [
            6:   [ 6, 22, 38, 54, 70, 86, 102, 118, 134, 150, 166, 182, 198, 214, 230, 246 ],
            223: [ 15, 31, 47, 63, 79, 95, 111, 127, 143, 159, 175, 191, 207, 223, 239, 255 ]
        ]

        for i in testDict.keys {
            XCTAssertEqual(columnForCell(i), testDict[i])
        }
    }

    func testRows() {
        let testDict: [Int: [Int]] = [
            6:   [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
            223: [ 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223 ]
        ]

        for i in testDict.keys {
            XCTAssertEqual(rowForCell(i), testDict[i])
        }
    }

    func testSquares() {
        let testDict: [Int: [Int]] = [
            6:   [ 4, 5, 6, 7, 20, 21, 22, 23, 36, 37, 38, 39, 52, 53, 54, 55 ],
            223: [ 204, 205, 206, 207, 220, 221, 222, 223, 236, 237, 238, 239, 252, 253, 254, 255 ]
        ]

        for i in testDict.keys {
            XCTAssertEqual(squareForCell(i), testDict[i])
        }
    }

    func testBoardCheck() {
        var checkData = (1...16).map { $0 }
        XCTAssertTrue(Board.check(checkData))
        checkData[0] = 16
        XCTAssertFalse(Board.check(checkData))
        checkData.append(0)
        XCTAssertFalse(Board.check(checkData))
    }

    func testBoardValues() {
        let board = Board()
        for variant in 0...1 {
            board.randomizeSolution(variant)
            for index in 0...15 {
                XCTAssertTrue(board.colCheck(index))
                XCTAssertTrue(board.rowCheck(index))
                XCTAssertTrue(board.sqrCheck(index))
            }
        }
    }

    func testBoard() {
        let test = Board()
        test.solution[124] = 4
        XCTAssertEqual(test.cells[123].canBe, Set16.all)
        _ = test.set(124, 4)
        XCTAssertNotEqual(test.cells[123].canBe, Set16.all)
        XCTAssertFalse(test.cells[123].canBe.contains(4))
        _ = test.set(124, 0)
        XCTAssertEqual(test.cells[123].canBe, Set16.all)
    }

    func testBoardPerformance() {
        let test = Board()
        self.measure {
            test.randomizeSolution()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.hint()
            test.copySolution()
        }
    }

    func testGlobalBoardPerformance() {
        self.measure {
            board.randomizeSolution()
            board.reCalcAll()
            board.copySolution()
        }
    }
}
