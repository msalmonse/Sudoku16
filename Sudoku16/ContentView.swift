//
//  ContentView.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

var board = Board.random

// which sheet to show
var showSheet = PublishingShowSheet(.none)

struct ContentView: View {
    @ObservedObject var settings = UserSettings()

    var body: some View {
        HStack {
            ScrollView([.horizontal, .vertical]) {
                BoardSquares()
            }
            Sheets()
        }
        .environmentObject(settings)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
