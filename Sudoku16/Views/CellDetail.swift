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
    let row: Int
    let col: Int
    @ObservedObject var cell: Cell
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(index: Int) {
        self.index = index
        row = (index >> 4) + 1
        col = (index & 0x0f) + 1
        cell = board.cells[index]
    }
    
    func enableButton(_ index: Int) -> Bool {
        return cell.value == 0 && cell.canBe.contains(index)
    }
    
    // Return a canBe button
    func canBeButton(_ number: Int) -> some View {
        return DetailButton(
            index: index,
            number: number,
            enable: cell.value == 0,
            color: cell.highlight[number].color,
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

    var body: some View {
        VStack {
            Text("Details for Cell, Row \(row), Column \(col)")
            .font(.title)
            Spacer()
            HStack {
                VStack {
                    Text("Set/Reset Cell")
                    .font(.headline)
                    Spacer()
                    HStack(alignment: VerticalAlignment.center) {
                        Button(
                            action: { _ = board.set(self.index, 0) },
                            label: { Image(systemName: "clear").font(.largeTitle) }
                        )
                        .foregroundColor((cell.value != 0) ? .primary : .secondary)
                        .disabled(cell.value == 0)
                        VStack {
                            numberRow(start:  1)
                            numberRow(start:  5)
                            numberRow(start:  9)
                            numberRow(start: 13)
                        }
                    }
                }
                .padding()
                .overlay(strokedRoundedRectangle(cornerRadius: 3))
                VStack {
                    Text("Set/Reset Tag")
                    .font(.headline)
                    Spacer()
                    HStack(alignment: VerticalAlignment.center) {
                        Button(
                            action: { _ = board.canBeRecalc(self.index) },
                            label: {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.largeTitle)
                            }
                        )
                        .foregroundColor(.primary )
                        .disabled(cell.value != 0)
                        VStack {
                            canBeRow(start:  1)
                            canBeRow(start:  5)
                            canBeRow(start:  9)
                            canBeRow(start: 13)
                        }
                    }
                }
                .padding()
                .overlay(strokedRoundedRectangle(cornerRadius: 3))
            }
            Spacer()
            
            Button(
                action: { self.mode.value.dismiss() },
                label: {
                    ButtonText(text: "Dismiss")
                }
            )
            Spacer()
        }
    }
}

struct DetailButton: View {
    let index: Int
    let number: Int
    let enable: Bool
    let color: Color
    let doIt: (() -> ())
    
    //@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        Button(
            action: doIt,
            label: { Image(systemName: nameForValue(number)).font(.largeTitle) }
        )
        .foregroundColor(enable ? .primary : .secondary)
        .opacity(enable ? 1.0 : 0.2)
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
