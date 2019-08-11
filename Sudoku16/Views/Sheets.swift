//
//  Sheets.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import Combine
import SwiftUI

struct IdInt: Identifiable {
    let id = UUID()
    var value: Int
}

struct Sheets: View {
    @State var showDetail: IdInt? = nil

    var body: some View {
        Text("")
        .hidden()
        .sheet(item: $showDetail, content: { i in CellDetail(index: i.value) } )
        .onReceive(showSheet.publisher,
            perform: { showIt in
                switch showIt {
                case .none: break
                case .cellDetail(let i): self.showDetail = IdInt(value: i)
                }
            }
        )
    }
}

#if DEBUG
struct Sheets_Previews: PreviewProvider {
    static var previews: some View {
        Sheets()
    }
}
#endif
