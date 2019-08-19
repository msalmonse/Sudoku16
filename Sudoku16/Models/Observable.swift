//
//  Observable.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Observable<T>: ObservableObject, Identifiable {
    let id = UUID()
    let objectWillChange = ObservableObjectPublisher()
    var value: T {
        willSet { objectWillChange.send() }
    }

    init(_ initialValue: T) { value = initialValue }
}

typealias ObservableInt = Observable<Int>
