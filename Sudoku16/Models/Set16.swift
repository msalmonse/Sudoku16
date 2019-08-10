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
let range16 = 0...15

extension Set16 {
    func contains(_ i: Int) -> Bool {
        if !range16.contains(i) { return false }
        return (self & (1 << i)) != 0
    }
    
    mutating func set(_ i: Int) {
        if range16.contains(i) { self |= (1 << i) }
    }
    
    mutating func unset(_ i: Int) {
        if range16.contains(i) { self &= ~(1 << i) }
    }
}
