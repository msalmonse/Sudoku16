//
//  CellView.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

// Convert a value to an image name

func nameForValue(_ i: Int) -> String {
    switch i {
    case  1: return  "1.square"
    case  2: return  "2.square"
    case  3: return  "3.square"
    case  4: return  "4.square"
    case  5: return  "5.square"
    case  6: return  "6.square"
    case  7: return  "7.square"
    case  8: return  "8.square"
    case  9: return  "9.square"
    case 10: return "10.square"
    case 11: return "11.square"
    case 12: return "12.square"
    case 13: return "13.square"
    case 14: return "14.square"
    case 15: return "15.square"
    case 16: return "16.square"
    default: return "square"
    }
}

struct CellView: View {
    let cell: Cell
    
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
        .frame(width: 85, height: 75)
        .overlay(strokedRoundedRectangle(cornerRadius: 1))
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
            CellView(cell: cell)
        }
    }
}
#endif
