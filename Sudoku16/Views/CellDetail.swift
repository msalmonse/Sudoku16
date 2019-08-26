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
    @State var rowHighlight: Bool = false
    @State var columnHighlight: Bool = false
    @State var squareHilight: Bool = true
    @State var highlight: CellHighlight = .user1
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.colorScheme) var scheme: ColorScheme

    var row: Int { (index >> 4) + 1 }
    var col: Int { (index & 0x0f) + 1 }

    init(index: Int) {
        cell = board.cells[index]
        self.index = index
    }

    private func starName(_ hi: CellHighlight) -> String {
        return hi == highlight ? "star.fill" : "star"
    }

    var body: some View {
        VStack {
            Text("Details for Cell, Row \(row), Column \(col)")
            .font(.title)
            Spacer()
            MiniBoard(selected: index)
            .padding(5)
            .overlay(strokedRoundedRectangle(cornerRadius: 2, stroke: 2))
            Spacer()
            HStack {
                VStack {
                    Text("Set/Clear Cell")
                    .font(.headline)
                    Spacer()
                    HStack(alignment: VerticalAlignment.center) {
                        Button(
                            action: { board.set(self.index, 0) },
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
                            action: { board.canBeRecalc(self.index) },
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
                            // Determine which cells to highlight
                            Text("On:")
                            Toggle(isOn: $rowHighlight, label: { Text("Row") })
                            Toggle(isOn: $columnHighlight, label: { Text("Column") })
                            Toggle(isOn: $squareHilight, label: { Text("Square") })

                            HStack {
                                // Which colour?
                                Text("Colour:")
                                Spacer()
                                Button(
                                    action: { self.highlight = .user0 },
                                    label: { Image(systemName: starName(.user0)) }
                                )
                                .foregroundColor(CellHighlight.user0.color)
                                Button(
                                    action: { self.highlight = .user1 },
                                    label: { Image(systemName: starName(.user1)) }
                                )
                                .foregroundColor(CellHighlight.user1.color)
                            }
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
                            ButtonText("Reset all", font: .body, scheme: scheme)
                    }
                    )
                }
                .padding()
                .frame(width: 400)
                .overlay(strokedRoundedRectangle(cornerRadius: 3))
            }
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
