//
//  CellSquareRow.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CellSquare: View {
    let start: Int
    
    var body: some View {
        VStack (spacing: 0) {
            CellRow(start: start)
            CellRow(start: start + 16)
            CellRow(start: start + 32)
            CellRow(start: start + 48)
        }
        .overlay(strokedRectangle(stroke: 3, color: .green))
    }
}

struct CellRow: View {
    let start: Int
    
    var body: some View {
        HStack (spacing: 0) {
            CellView(cell: board.cells[start])
            CellView(cell: board.cells[start + 1])
            CellView(cell: board.cells[start + 2])
            CellView(cell: board.cells[start + 3])
        }
    }
}

#if DEBUG
struct CellRow_Previews: PreviewProvider {
    static var previews: some View {
        CellSquare(start: 0)
    }
}
#endif
