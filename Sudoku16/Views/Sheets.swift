//
//  Sheets.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-11.
//  Copyright © 2019 mesme. All rights reserved.
//

import Combine
import SwiftUI

struct Sheets: View {
    @State var detailIndex: Int = 0
    @State var showDetail: Bool = false
    @State var showUserSettings = false
    @State var alertMessage: Message? = nil

    var body: some View {
        VStack {
            Text("").hidden()
            .sheet(isPresented: $showDetail) { DetailNavigation(index: self.$detailIndex) }

            Text("").hidden()
            .sheet(isPresented: $showUserSettings) { Settings() }

            Text("").hidden()
                .alert(item: $alertMessage) { msg in
                    Alert(
                        title: Text(msg.subject ?? "Alert"),
                        message: Text(msg.text),
                        dismissButton: Alert.Button.default(Text("Dismiss"))
                    )
                }

            Text("").hidden()
            .onReceive(showSheet.publisher,
                perform: { showIt in
                    switch showIt {
                    case .none: break
                    case .cellDetail(let idx):
                        self.detailIndex = idx
                        self.showDetail = true
                    case .showAlert(let msg): self.alertMessage = msg
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
