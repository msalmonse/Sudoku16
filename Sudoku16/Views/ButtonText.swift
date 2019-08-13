//
//  ButtonText.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-13.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

/// Standard button Text()

struct ButtonText: View {
    let text: String
    
    var body: some View {
        Text(text)
        .font(.largeTitle)
        .foregroundColor(.primary)
        .padding()
        .frame(width: 200)
        .overlay(strokedCapsule())
    }
}

#if DEBUG
struct ButtonText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonText(text: "Hello World")
    }
}
#endif
