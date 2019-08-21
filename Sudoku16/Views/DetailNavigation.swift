//
//  DetailNavigation.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-13.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate enum Direction {
    case up, down, left, right

    var symbol: String {
        switch self {
        case .up:    return "arrowtriangle.up.square"
        case .down:  return "arrowtriangle.down.square"
        case .left:  return "arrowtriangle.left.square"
        case .right: return "arrowtriangle.right.square"
        }
    }
}
struct DetailNavigation: View {
    @Binding var index: Int
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            CellDetail(index: index)
            Spacer()
            VStack(alignment: HorizontalAlignment.center, spacing: 3) {
                NavButton(
                    index: $index,
                    direction: .up,
                    next: (index > 15) ? index - 16 : -1
                )
                HStack(alignment: VerticalAlignment.center, spacing: 3) {
                    NavButton(
                        index: $index,
                        direction: .left,
                        next: ((index & 15) > 0) ? index - 1 : -1
                    )
                    NavButton(
                        index: $index,
                        direction: .down,
                        next: (index < 240) ? index + 16 : -1
                    )
                    NavButton(
                        index: $index,
                        direction: .right,
                        next: ((index & 15) < 15) ? index + 1 : -1
                    )

                }
                Spacer()
                Button(
                    action: { self.mode.wrappedValue.dismiss() },
                    label: {
                        ButtonText("Dismiss")
                    }
                )
                Spacer()
            }
        }
    }
}

fileprivate struct NavButton: View {
    @Binding var index: Int
    let direction: Direction
    let next: Int
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        Button(
            action: {
                self.index = self.next
            },
            label: {
                Image(systemName: direction.symbol)
                .font(.largeTitle)
                .foregroundColor(.primary)
            }
        )
        .disabled(next < 0)
    }
}

#if DEBUG
struct DetailNavigation_Previews: PreviewProvider {
    static var previews: some View {
        DetailNavigation(index: .constant(120))
    }
}
#endif
