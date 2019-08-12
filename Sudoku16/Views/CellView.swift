//
//  CellView.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate func cellHighlight(_ cell: Cell) -> Cell {
    var hi: CellHighlight = .none
    switch cell.canBe.count {
    case 1: hi = .canBe1
    case 2: hi = .canBe2
    default: break
    }
    for i in range16 {
        cell.highlight[i] = cell.canBe.contains(i) ? hi : .none
    }
    return cell
}

struct CellButton: View {
    let index: Int
    
    var body: some View {
        Button(
            action: { showSheet.value = .cellDetail(self.index) },
            label: {
                CellView(cell: board.cells[self.index], width: 85, height: 85)
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
                Image(systemName: nameForValue(cell.value))
                .font(Font.largeTitle.weight(.semibold))
            }
            else {
                CanBeView(cell: cellHighlight(cell))
            }
        }
        .frame(width: width, height: height)
        .scaleEffect(min(width, height)/85.0)
        .overlay(strokedRoundedRectangle(cornerRadius: width/85.0))
        .foregroundColor(.primary)
    }
}

struct CanBeView: View {
    @ObservedObject var cell: Cell
    
    var body: some View {
        VStack(spacing: 5) {
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
        HStack(spacing: 2) {
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
    let name: String
    
    init(cell: Cell, index: Int) {
        show = cell.canBe.contains(index)
        name = nameForValue(show ? index : 0)
        color = show ? cell.highlight[index].color : .secondary
        self.cell = cell
    }
    
    var body: some View {
        Image(systemName: name)
        .opacity(show ? 1.0 : 0.1)
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
