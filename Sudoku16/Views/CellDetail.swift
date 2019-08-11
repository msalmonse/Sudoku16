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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(index: Int) {
        self.index = index
        cell = board.cells[index]
    }
    
    func enableButton(_ index: Int) -> Bool {
        return cell.value == 0 && cell.canBe.contains(index)
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
                    NumberButton(index: index, number: 1, enable: enableButton(1))
                    NumberButton(index: index, number: 2, enable: enableButton(2))
                    NumberButton(index: index, number: 3, enable: enableButton(3))
                    NumberButton(index: index, number: 4, enable: enableButton(4))
                    NumberButton(index: index, number: 5, enable: enableButton(5))
                    NumberButton(index: index, number: 6, enable: enableButton(6))
                    NumberButton(index: index, number: 6, enable: enableButton(7))
                    NumberButton(index: index, number: 8, enable: enableButton(8))
                }
                Group {
                    NumberButton(index: index, number: 9, enable: enableButton(9))
                    NumberButton(index: index, number: 10, enable: enableButton(10))
                    NumberButton(index: index, number: 11, enable: enableButton(11))
                    NumberButton(index: index, number: 12, enable: enableButton(12))
                    NumberButton(index: index, number: 13, enable: enableButton(13))
                    NumberButton(index: index, number: 14, enable: enableButton(14))
                    NumberButton(index: index, number: 15, enable: enableButton(15))
                    NumberButton(index: index, number: 16, enable: enableButton(16))
                }
            }
            Spacer()
            Button(
                action: { self.mode.value.dismiss() },
                label: {
                    Text("Dismiss")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding()
                    .overlay(strokedRoundedRectangle(cornerRadius: 10))
                }
            )
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
