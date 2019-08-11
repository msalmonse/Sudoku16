//
//  Set16.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

/// A set of 16 bits

typealias Set16 = UInt16

let all16: Set16 = 0xffff
let range16 = 1...16

extension Set16 {
    private func mask(_ i: Int) -> UInt16 { return UInt16(1 << (i - 1)) }

    func contains(_ i: Int) -> Bool {
        if !range16.contains(i) { return false }
        return (self & mask(i)) != 0
    }
    
    mutating func set(_ i: Int, _ set: Bool) -> Bool {
        let was = self.contains(i)
        if range16.contains(i) {
            if (set) { self |= mask(i) }
            else { self &= ~mask(i)}
        }
        return was
    }
}
