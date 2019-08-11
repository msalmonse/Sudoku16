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
                CellView(cell: board.cells[self.index], width: 85, height: 75)
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
                .font(Font.largeTitle.weight(.bold))
            }
            else {
                CanBeView(canBe: cell.canBe)
            }
        }
        .frame(width: width, height: height)
        .overlay(strokedRoundedRectangle(cornerRadius: 1))
        .foregroundColor(.primary)
    }
}

struct CanBeView: View {
    let canBe: Set16
    
    var body: some View {
        VStack(spacing: 3) {
            MiniCellRow(canBe: canBe, start: 1)
            MiniCellRow(canBe: canBe, start: 5)
            MiniCellRow(canBe: canBe, start: 9)
            MiniCellRow(canBe: canBe, start: 13)
        }
    }
}

struct MiniCellRow: View {
    let canBe: Set16
    let start: Int
    
    var body: some View {
        HStack(spacing: 3) {
            MiniCellView(canBe: canBe, index: start)
            MiniCellView(canBe: canBe, index: start + 1)
            MiniCellView(canBe: canBe, index: start + 2)
            MiniCellView(canBe: canBe, index: start + 3)
        }

    }
}

struct MiniCellView: View {
    let index: Int
    let show: Bool
    
    init(canBe: Set16, index: Int) {
        show = canBe.contains(index)
        self.index = show ? index : 0
    }
    
    var body: some View {
        Image(systemName: nameForValue(index))
        .opacity(show ? 1.0 : 0.1)
        .scaledToFit()
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
