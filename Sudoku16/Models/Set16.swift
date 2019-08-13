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
let none16: Set16 = 0x0000
let range16 = 1...16

extension Set16 {
    private func mask(_ i: Int) -> UInt16 { return UInt16(1 << (i - 1)) }

    func contains(_ i: Int) -> Bool {
        if !range16.contains(i) { return false }
        return (self & mask(i)) != 0
    }
    
    
    var count: Int { return self.nonzeroBitCount }
    var isEmpty: Bool { return self == none16 }
    var list: [Int] {
        var ret: [Int] = []
        for i in range16 {
            if self.contains(i) { ret.append(i) }
        }
        return ret
    }
    
    mutating func set(_ i: Int, _ setTo: Bool) -> Bool {
        let was = self.contains(i)
        if range16.contains(i) {
            if (setTo) { self |= mask(i) }
            else { self &= ~mask(i)}
        }
        return was
    }
    
    mutating func setOnly(_ i: Int) {
        if range16.contains(i) { self = mask(i) }
    }

    mutating func toggle(_ i: Int) -> Bool {
        let was = self.contains(i)
        if range16.contains(i) { self ^= mask(i) }
        return was
    }
}
