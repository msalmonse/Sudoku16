//
//  SwapT.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-12.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func swap<T>(_ a: inout T, _ b: inout T) {
    let t = a
    a = b
    b = t
}
