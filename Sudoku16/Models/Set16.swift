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

extension Set16 {
    static let range = 1...16
    static let all: Set16 = 0xffff
    static let empty: Set16 = 0x0000

    private func mask(_ member: Int) -> UInt16 {
        return UInt16(1 << (member - Self.range.lowerBound))
    }

    func contains(_ member: Int) -> Bool {
        if !Set16.range.contains(member) { return false }
        return (self & mask(member)) != 0
    }

    var count: Int { return self.nonzeroBitCount }
    var isEmpty: Bool { return self == Set16.empty }
    var list: [Int] {
        var ret: [Int] = []
        for member in Set16.range where self.contains(member) {
            ret.append(member)
        }
        return ret
    }

    @discardableResult
    mutating func set(_ member: Int, _ setTo: Bool) -> Bool {
        let was = self.contains(member)
        if Set16.range.contains(member) {
            if setTo { self |= mask(member) } else { self &= ~mask(member) }
        }
        return was
    }

    mutating func setOnly(_ member: Int) {
        if Set16.range.contains(member) { self = mask(member) }
    }

    @discardableResult
    mutating func toggle(_ member: Int) -> Bool {
        let was = self.contains(member)
        if Set16.range.contains(member) { self ^= mask(member) }
        return was
    }

    /// Another way to check or set membership
    subscript(index: Int) -> Bool {
        get {
            contains(index)
        }
        set(newValue) {
            set(index, newValue)
        }
    }

    /// Constant values with only 1 set member
    static subscript(index: Int) -> Set16 {
        return Set16.all.mask(index)
    }
}
