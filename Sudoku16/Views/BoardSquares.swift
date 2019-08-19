//
//  BoardSquares.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct BoardSquares: View {
    @State var autofilled = board.autofilled.value
    @State var hints = board.hintCount.value
    @State var erred = board.erred.value
    @State var unsolved = board.unsolved.value

    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 1) {
            Text(
                "Unsolved: \(unsolved), hints: \(hints), errors: \(erred), autofilled: \(autofilled)"
            )
            .font(.body)
            .onReceive(
                board.unsolved.publisher,
                perform: {
                    self.unsolved = $0
                    if $0 == 0 {
                        showSheet.value = .showAlert(
                            Message("All cells solved", subject: "Game over")
                        )
                    }
                }
            )
            .onReceive(board.autofilled.publisher, perform: { self.autofilled = $0 })
            .onReceive(board.erred.publisher, perform: { self.erred = $0 })
            .onReceive(board.hintCount.publisher, perform: { self.hints = $0 })

            HStack {
                VStack(alignment: HorizontalAlignment.center, spacing: 0) {
                    SquaresRow(start: 0)
                    SquaresRow(start: 64)
                    SquaresRow(start: 128)
                    SquaresRow(start: 192)
                }
                .overlay(strokedRectangle(stroke: 3))
            }
            .padding()

            HStack {
                Button(
                    action: { board.renew() },
                    label: { ButtonText("New") }
                )

                Button(
                    action: { board.restart() },
                    label: { ButtonText("Restart") }
                )

                Button(
                    action: { board.solve() },
                    label: { ButtonText("Solve") }
                )

                Button(
                    action: { board.hint() },
                    label: { ButtonText("Hint") }
                )

                Button(
                    action: { showSheet.value = .userSettings },
                    label: { ButtonText("Settings") }
                )
            }
        }
    }
}

struct SquaresRow: View {
    let start: Int

    var body: some View {
        HStack (spacing: 0) {
            CellSquare(start: start)
            CellSquare(start: start + 4)
            CellSquare(start: start + 8)
            CellSquare(start: start + 12)
        }
    }
}

#if DEBUG
struct BoardSquares_Previews: PreviewProvider {
    static var previews: some View {
        BoardSquares()
    }
}
#endif
