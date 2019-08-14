//
//  CellDetailButtons.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-14.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import SwiftUI

extension CellDetail {
    func enableButton(_ index: Int) -> Bool {
        return cell.value == 0 && cell.canBe.contains(index)
    }
    
    // Return a canBe button
    func canBeButton(_ number: Int) -> some View {
        let color: Color = cell.canBe.contains(number) ? .primary : .secondary
        return DetailButton(
            index: index,
            number: number,
            enable: cell.value == 0,
            color: color,
            doIt: {
                _ = self.cell.canBe.toggle(number)
            }
        )
    }
    
    // Return a canBe row
    func canBeRow(start: Int) -> some View {
        return HStack {
            canBeButton(start + 0)
            canBeButton(start + 1)
            canBeButton(start + 2)
            canBeButton(start + 3)
        }
    }

    // Return a number button
    func numberButton(_ number: Int) -> some View {
        let enable = enableButton(number)
        return DetailButton(
            index: index,
            number: number,
            enable: enable,
            color: enable ? .primary : .secondary,
            doIt: {
                _ = board.set(self.index, number)
                self.mode.value.dismiss()
            }
        )
    }
    
    // Return a number row
    func numberRow(start: Int) -> some View {
        return HStack {
            numberButton(start + 0)
            numberButton(start + 1)
            numberButton(start + 2)
            numberButton(start + 3)
        }
    }
    
    // Return a highlight button
    func highlightButton(_ number: Int) -> some View {
        let color: Color = (cell.highlight[number] == .user) ? .secondary : .primary
        return DetailButton(
            index: index,
            number: number,
            enable: true,
            color: color,
            doIt: {
                board.highlight(
                    self.index,
                    number,
                    self.rowHighlight,
                    self.columnHighlight,
                    self.squareHilight
                )
            }
        )
    }
    
    // Return a highlight row
    func highlightRow(start: Int) -> some View {
        return HStack {
            highlightButton(start + 0)
            highlightButton(start + 1)
            highlightButton(start + 2)
            highlightButton(start + 3)
        }
    }

}

struct DetailButton: View {
    let index: Int
    let number: Int
    let enable: Bool
    let color: Color
    let doIt: (() -> ())
    
    var body: some View {
        Button(
            action: doIt,
            label: { Image(systemName: nameForValue(number)).font(.largeTitle) }
        )
        .foregroundColor(color)
        .opacity(enable ? 1.0 : 0.3)
        .disabled(!enable)

    }
}
