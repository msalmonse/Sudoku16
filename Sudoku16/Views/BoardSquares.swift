//
//  BoardSquares.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct BoardSquares: View {
    var body: some View {
        VStack(spacing: 0) {
            SquaresRow(start: 0)
            SquaresRow(start: 64)
            SquaresRow(start: 128)
            SquaresRow(start: 192)
        }
    .overlay(strokedRectangle(stroke: 3))
    }
}

struct SquaresRow: View {
    let start: Int
    
    var body: some View {
        HStack (spacing: 0) {
            CellSquare(start: start)
            CellSquare(start: start + 4)
            CellSquare(start: start + 8)
            CellSquare(start: start + 12)
        }
    }
}

#if DEBUG
struct BoardSquares_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquares()
    }
}
#endif
