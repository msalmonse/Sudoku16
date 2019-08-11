//
//  CellDetail.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CellDetail: View {
    let index: Int
    let cell: Cell
    
    init(index: Int) {
        self.index = index
        cell = board.cells[index]
    }

    var body: some View {
        VStack {
            CellView(cell: cell, width: 340, height: 300)
            HStack(spacing: 3) {
                Button(
                    action: { _ = board.set(self.index, 0) },
                    label: { Image(systemName: "clear").font(.title) }
                )
                .disabled(cell.value == 0)
                Group {
                    NumberButton(index: index, number: 1, enable: cell.canBe.contains(1))
                    NumberButton(index: index, number: 2, enable: cell.canBe.contains(2))
                    NumberButton(index: index, number: 3, enable: cell.canBe.contains(3))
                    NumberButton(index: index, number: 4, enable: cell.canBe.contains(4))
                    NumberButton(index: index, number: 5, enable: cell.canBe.contains(5))
                    NumberButton(index: index, number: 6, enable: cell.canBe.contains(6))
                    NumberButton(index: index, number: 6, enable: cell.canBe.contains(7))
                    NumberButton(index: index, number: 8, enable: cell.canBe.contains(8))
                }
                Group {
                    NumberButton(index: index, number: 9, enable: cell.canBe.contains(9))
                    NumberButton(index: index, number: 10, enable: cell.canBe.contains(10))
                    NumberButton(index: index, number: 11, enable: cell.canBe.contains(11))
                    NumberButton(index: index, number: 12, enable: cell.canBe.contains(12))
                    NumberButton(index: index, number: 13, enable: cell.canBe.contains(13))
                    NumberButton(index: index, number: 14, enable: cell.canBe.contains(14))
                    NumberButton(index: index, number: 15, enable: cell.canBe.contains(15))
                    NumberButton(index: index, number: 16, enable: cell.canBe.contains(16))
                }
            }
        }
    }
}

struct NumberButton: View {
    let index: Int
    let number: Int
    let enable: Bool
    
    var body: some View {
        Button(
            action: { _ = board.set(self.index, self.number) },
            label: { Image(systemName: nameForValue(number)).font(.title) }
        )
        .disabled(!enable)

    }
}

#if DEBUG
struct CellDetail_Previews: PreviewProvider {
    static var previews: some View {
        CellDetail(index: Int.random(in: 0...255))
    }
}
#endif
