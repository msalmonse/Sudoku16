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
    @ObservedObject var cell: Cell
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var rowHighlight: Bool = false
    @State var columnHighlight: Bool = false
    @State var squareHilight: Bool = true

    var row: Int { (index >> 4) + 1 }
    var col: Int { (index & 0x0f) + 1 }

    init(index: Int) {
        cell = board.cells[index]
        self.index = index
    }

    var body: some View {
        VStack {
            Text("Details for Cell, Row \(row), Column \(col)")
            .font(.title)
            Spacer()
            HStack {
                VStack {
                    Text("Set/Clear Cell")
                    .font(.headline)
                    Spacer()
                    HStack(alignment: VerticalAlignment.center) {
                        Button(
                            action: { _ = board.set(self.index, 0) },
                            label: { Image(systemName: "clear").font(.largeTitle) }
                        )
                        .foregroundColor((cell.value != 0) ? .primary : .secondary)
                        .disabled(cell.value == 0)
                        VStack(spacing: 12) {
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
                    Text("Set/Clear Tag")
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
                        VStack(spacing: 12) {
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

            HStack {
                VStack {
                    Text("Set/Clear Highlight")
                    .font(.headline)
                    Spacer()
                    HStack(alignment: VerticalAlignment.center) {
                        VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
                            Text("On:")
                            Toggle(isOn: $rowHighlight, label: { Text("Row") })
                            Toggle(isOn: $columnHighlight, label: { Text("Column") })
                            Toggle(isOn: $squareHilight, label: { Text("Square") })
                        }
                        Divider().padding()
                        VStack(spacing: 12) {
                            highlightRow(start:  1)
                            highlightRow(start:  5)
                            highlightRow(start:  9)
                            highlightRow(start: 13)
                        }
                    }
                    Button(
                        action: { board.reCalcAll() },
                        label: {
                            ButtonText("Reset all", font: .body)
                    }
                    )
                }
                .padding()
                .frame(width: 400)
                .overlay(strokedRoundedRectangle(cornerRadius: 3))
            }
            Spacer()

            // FixME DetailNavigation(index: index)

            Button(
                action: { self.mode.value.dismiss() },
                label: {
                    ButtonText("Dismiss")
                }
            )
            Spacer()
        }
    }
}

#if DEBUG
struct CellDetail_Previews: PreviewProvider {
    static var previews: some View {
        CellDetail(index: Int.random(in: 0...255))
    }
}
#endif
