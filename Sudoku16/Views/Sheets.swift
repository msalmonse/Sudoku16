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
    @State var showUserSettings = false

    var body: some View {
        VStack {
            Text("").hidden()
            .sheet(item: $showDetail, content: { i in CellDetail(index: i.value) } )

            Text("").hidden()
            .sheet(isPresented: $showUserSettings, content: { Settings() })

            Text("").hidden()
            .onReceive(showSheet.publisher,
                perform: { showIt in
                    switch showIt {
                    case .none: break
                    case .cellDetail(let i): self.showDetail = IdInt(value: i)
                    case .userSettings: self.showUserSettings = true
                    }
                }
            )
        }.hidden()
    }
}

#if DEBUG
struct Sheets_Previews: PreviewProvider {
    static var previews: some View {
        Sheets()
    }
}
#endif
