//
//  ContentView.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

let board = Board()

struct ContentView: View {
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            BoardSquares()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
