//
//  ShowSheet.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

/// enum to determine which sheet to show

enum ShowSheet {
    case none
    case cellDetail(Int)
    case userSettings
}

typealias PublishingShowSheet = Publishing<ShowSheet>
