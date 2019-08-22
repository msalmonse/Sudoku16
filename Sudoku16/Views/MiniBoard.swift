//
//  MiniBoard.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-21.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct MiniBoard: View {
    let selected: Int
    let rows: [IddInt]

    init(selected: Int) {
        let range = 0...15
        rows = range.map { IddInt($0) }
        self.selected = selected
    }

    var body: some View {
        VStack(spacing: 1) {
            ForEach(rows) { row in
                MiniRow(row: row.value, selected: self.selected)
            }
        }
    }
}

struct MiniRow: View {
    let row: Int
    let rowIndex: [IddInt]
    let selected: Int
    @Environment(\.colorScheme) var scheme: ColorScheme

    init(row: Int, selected: Int) {
        let range = (row << 4)...(row << 4 | 15)
        rowIndex = range.map { IddInt($0) }
        self.row = row
        self.selected = selected
    }

    var body: some View {
        HStack(spacing: 1) {
            Image(systemName: nameForValue(row + 1))
            .padding(.trailing, 3)
            .foregroundColor(.primary)
            ForEach (rowIndex) {index in
                Image(systemName:
                    index.value == self.selected ? "clear" : board.cells[index.value].name
                )
                .font(.title)
                .background(
                    filledRectangle(
                        color: squareColor(index.value, selected: self.selected, scheme: self.scheme)
                    )
                )
            }
        }
    }
}

struct MiniBoard_Previews: PreviewProvider {
    static var previews: some View {
        MiniBoard(selected: 132)
    }
}
