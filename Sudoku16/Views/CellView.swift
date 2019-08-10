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
    case  0: return "16.circle"
    case  1: return  "1.circle"
    case  2: return  "2.circle"
    case  3: return  "3.circle"
    case  4: return  "4.circle"
    case  5: return  "5.circle"
    case  6: return  "6.circle"
    case  7: return  "7.circle"
    case  8: return  "8.circle"
    case  9: return  "9.circle"
    case 10: return "10.circle"
    case 11: return "11.circle"
    case 12: return "12.circle"
    case 13: return "13.circle"
    case 14: return "14.circle"
    case 15: return "15.circle"
    default: return "clear"
    }
}

struct CellView: View {
    let cell: Cell
    
    var body: some View {
        ZStack {
            if cell.value < 16 && cell.value >= 0 {
                Image(systemName: nameForValue(cell.value))
                    .font(Font.largeTitle.weight(.bold))
            }
            else {
                CanBeView(canBe: cell.canBe)
            }
        }
        .frame(width: 80, height: 80)
        .overlay(strokedRectangle())
    }
}

struct CanBeView: View {
    let canBe: Set16
    
    var body: some View {
        VStack {
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
        HStack {
            MiniCellView(canBe: canBe, index: start)
            MiniCellView(canBe: canBe, index: start + 1)
            MiniCellView(canBe: canBe, index: start + 2)
            MiniCellView(canBe: canBe, index: (start < 13) ? start + 3 : 0)
        }

    }
}

struct MiniCellView: View {
    let canBe: Set16
    let index: Int
    
    var body: some View {
        Image(systemName: nameForValue(canBe.contains(index) ? index : -1))
            .font(.footnote)
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
