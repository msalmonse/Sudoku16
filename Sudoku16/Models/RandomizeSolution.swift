//
//  RandomizeSolution.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-12.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

fileprivate let solutions = [
    [                                                                      // Row #
         1,  2,  3,  4,    5,  6,  7,  8,    9, 10, 11, 12,   13, 14, 15, 16, //  1
         5,  6,  7,  8,    9, 10, 11, 12,   13, 14, 15, 16,    1,  2,  3,  4, //  2
         9, 10, 11, 12,   13, 14, 15, 16,    1,  2,  3,  4,    5,  6,  7,  8, //  3
        13, 14, 15, 16,    1,  2,  3,  4,    5,  6,  7,  8,    9, 10, 11, 12, //  4

         3,  4,  1,  2,    7,  8,  5,  6,   11, 12,  9, 10,   15, 16, 13, 14, //  5
         7,  8,  5,  6,   11, 12,  9, 10,   15, 16, 13, 14,    3,  4,  1,  2, //  6
        11, 12,  9, 10,   15, 16, 13, 14,    3,  4,  1,  2,    7,  8,  5,  6, //  7
        15, 16, 13, 14,    3,  4,  1,  2,    7,  8,  5,  6,   11, 12,  9, 10, //  8

         4,  1,  2,  3,    8,  5,  6,  7,   12,  9, 10, 11,   16, 13, 14, 15, //  9
         8,  5,  6,  7,   12,  9, 10, 11,   16, 13, 14, 15,    4,  1,  2,  3, // 10
        12,  9, 10, 11,   16, 13, 14, 15,    4,  1,  2,  3,    8,  5,  6,  7, // 11
        16, 13, 14, 15,    4,  1,  2,  3,    8,  5,  6,  7,   12,  9, 10, 11, // 12

         2,  3,  4,  1,    6,  7,  8,  5,   10, 11, 12,  9,   14, 15, 16, 13, // 13
         6,  7,  8,  5,   10, 11, 12,  9,   14, 15, 16, 13,    2,  3,  4,  1, // 14
        10, 11, 12,  9,   14, 15, 16, 13,    2,  3,  4,  1,    6,  7,  8,  5, // 15
        14, 15, 16, 13,    2,  3,  4,  1,    6,  7,  8,  5,   10, 11, 12,  9  // 16
    ],
    [                                                                      // Row #
         1,  5,  9, 13,    3,  7, 11, 15,    4,  8, 12, 16,   2,  6, 10, 14,  //  1
         2,  6, 10, 14,    4,  8, 12, 16,    1,  5,  9, 13,   3,  7, 11, 15,  //  2
         3,  7, 11, 15,    1,  5,  9, 13,    2,  6, 10, 14,   4,  8, 12, 16,  //  3
         4,  8, 12, 16,    2,  6, 10, 14,    3,  7, 11, 15,   1,  5,  9, 13,  //  4

         5,  9, 13,  1,    7, 11, 15,  3,    8, 12, 16,  4,   6, 10, 14,  2,  //  5
         6, 10, 14,  2,    8, 12, 16,  4,    5,  9, 13,  1,   7, 11, 15,  3,  //  6
         7, 11, 15,  3,    5,  9, 13,  1,    6, 10, 14,  2,   8, 12, 16,  4,  //  7
         8, 12, 16,  4,    6, 10, 14,  2,    7, 11, 15,  3,   5,  9, 13,  1,  //  8

         9, 13,  1,  5,   11, 15,  3,  7,   12, 16,  4,  8,  10, 14,  2,  6,  //  9
        10, 14,  2,  6,   12, 16,  4,  8,    9, 13,  1,  5,  11, 15,  3,  7,  // 10
        11, 15,  3,  7,    9, 13,  1,  5,   10, 14,  2,  6,  12, 16,  4,  8,  // 11
        12, 16,  4,  8,   10, 14,  2,  6,   11, 15,  3,  7,   9, 13,  1,  5,  // 12

        13,  1,  5,  9,   15,  3,  7, 11,   16,  4,  8, 12,   9, 13,  1,  5,  // 13
        14,  2,  6, 10,   16,  4,  8, 12,   13,  1,  5,  9,  15,  3,  7, 11,  // 14
        15,  3,  7, 11,   13,  1,  5,  9,   14,  2,  6, 10,  16,  4,  8, 12,  // 15
        16,  4,  8, 12,   14,  2,  6, 10,   15,  3,  7, 11,  13,  1,  5,  9   // 16
    ]
]

extension Board {

    func swapColumns(_ a: Int, _ b: Int) {
        for i in stride(from: 0, to: 256, by: 16) {
            let t = solution[a + i]
            solution[a + i] = solution[b + i]
            solution[b + i] = t
        }
    }

    func swapRows(_ a: Int, _ b: Int) {
        for i in 0...15 {
            let t = solution[a + i]
            solution[a + i] = solution[b + i]
            solution[b + i] = t
        }
    }

    func swapColumnsInSquare(_ a: Int) {
        let b = (a & ~3) + Int.random(in: 0...3) // Random column in the same square
        if a != b { swapColumns(a, b) }
    }

    func swapRowsInSquare(_ a: Int) {
        let b = (a & ~0x30) + Int.random(in: 0...3) << 4 // Random column in the same square
        if a != b { swapRows(a, b) }
    }

    // Swap all the columns between two columns of squares
    func swapSquaresInColumn(_ square: Int) {
        let a = square << 2
        let b = Int.random(in: 0...3) << 2
        if a != b {
            swapColumns(a, b)
            swapColumns(a + 1, b + 1)
            swapColumns(a + 2, b + 2)
            swapColumns(a + 3, b + 3)
        }
    }

    // Swap all the rows between two rows of squares
    func swapSquaresInRow(_ square: Int) {
        let a = square << 6
        let b = Int.random(in: 0...3) << 6
        if a != b {
            swapRows(a, b)
            swapRows(a + 16, b + 16)
            swapRows(a + 32, b + 32)
            swapRows(a + 48, b + 48)
        }
    }

    func randomizeSolution() {
        let digitSwap = [0] + Array(1...16).shuffled()
        let variant = Int.random(in: solutions.indices)
        solution = solutions[variant].map { digitSwap[$0] }
        for _ in 0...9 {
            swapColumnsInSquare(Int.random(in: 0...15))
            swapRowsInSquare(Int.random(in: 0...15) << 4)
        }
        swapSquaresInColumn(Int.random(in: 0...3))
        swapSquaresInRow(Int.random(in: 0...3))
    }
}
