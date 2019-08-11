//
//  Publishing.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import Combine

/// Generic wrapper for publishing data

class Publishing<T> {
    var publisher = PassthroughSubject<T, Never>()
    var value: T {
        didSet { publisher.send(value) }
    }
    
    init(_ initialValue: T) { self.value = initialValue }
}

typealias PublishingString = Publishing<String>
