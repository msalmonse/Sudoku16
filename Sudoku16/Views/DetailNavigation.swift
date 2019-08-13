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
    let index: Int
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 3) {
            NavButton(
                direction: .up,
                next: (index > 15) ? index - 16 : -1
            )
            HStack(alignment: VerticalAlignment.center, spacing: 3) {
                NavButton(
                    direction: .left,
                    next: ((index & 15) > 0) ? index - 1 : -1
                )
                NavButton(
                    direction: .down,
                    next: (index < 240) ? index + 16 : -1
                )
                NavButton(
                    direction: .right,
                    next: ((index & 15) < 15) ? index + 1 : -1
                )

            }
        }
    }
}

fileprivate struct NavButton: View {
    let direction: Direction
    let next: Int
    
    var body: some View {
        Button(
            action: { showSheet.value = .cellDetail(self.next) },
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
        DetailNavigation(index: 120)
    }
}
#endif
