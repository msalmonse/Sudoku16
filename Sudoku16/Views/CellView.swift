//
//  CellView.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CellButton: View {
    let index: Int

    var body: some View {
        Button(
            action: { showSheet.value = .cellDetail(self.index) },
            label: {
                CellView(cell: board.cells[self.index], width: 50, height: 60)
            }
        )
    }
}

struct CellView: View {
    @ObservedObject var cell: Cell
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            if cell.value <= 16 && cell.value > 0 {
                Image(systemName: cell.name)
                .font(Font.largeTitle.weight(.semibold))
                .foregroundColor(cell.valueColor)
            } else {
                CanBeView(cell: cell)
            }
        }
        .frame(width: width, height: height)
        .overlay(strokedRoundedRectangle(cornerRadius: 1, color: cell.borderColor))
        .background(cell.backgroundColor)
    }
}

struct CanBeView: View {
    @ObservedObject var cell: Cell

    var body: some View {
        VStack(spacing: 0) {
            MiniCellRow(cell: cell, start: 1)
            MiniCellRow(cell: cell, start: 5)
            MiniCellRow(cell: cell, start: 9)
            MiniCellRow(cell: cell, start: 13)
        }
    }
}

struct MiniCellRow: View {
    @ObservedObject var cell: Cell
    let start: Int

    var body: some View {
        HStack(spacing: 0) {
            MiniCellView(cell: cell, index: start)
            MiniCellView(cell: cell, index: start + 1)
            MiniCellView(cell: cell, index: start + 2)
            MiniCellView(cell: cell, index: start + 3)
        }

    }
}

struct MiniCellView: View {
    @ObservedObject var cell: Cell
    let show: Bool
    let color: Color

    init(cell: Cell, index: Int) {
        show = cell.canBe[index]
        color = show ? cell.highlight[index].color : .secondary
        self.cell = cell
    }

    var body: some View {
        Text(show ? "◼︎" : "◻︎")
        .font(.caption)
        .opacity(show ? 1.0 : 0.2)
        .foregroundColor(color)
    }
}
#if DEBUG
struct Cell_Previews: PreviewProvider {
    static let cell = Cell()
    static var previews: some View {
        VStack {
            CellView(cell: cell, width: 85, height: 75)
        }
    }
}
#endif
