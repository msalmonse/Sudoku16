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
        .background(filledRoundedRectangle(cornerRadius: 3, color: squareColor(start)))
        .overlay(strokedRoundedRectangle(cornerRadius: 3, stroke: 3))
    }
}

struct CellRow: View {
    let start: Int

    var body: some View {
        HStack (spacing: 0) {
            CellButton(index: start)
            CellButton(index: start + 1)
            CellButton(index: start + 2)
            CellButton(index: start + 3)
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
