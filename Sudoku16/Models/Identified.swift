//
//  Identified.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-21.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

struct Identified<T>: Identifiable {
    let id = UUID()
    let value: T

    init(_ initialValue: T) {
        value = initialValue
    }
}

typealias IddInt = Identified<Int>
typealias IddString = Identified<String>
