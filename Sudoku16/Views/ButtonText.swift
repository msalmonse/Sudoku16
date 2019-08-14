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
        .frame(width: 180, height: 60)
        .overlay(strokedCapsule())
        .background(backgroundGradient())
        .clipShape(Capsule())
    }
}

private func backgroundGradient() -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(colors: [ .white, .blue, .blue, .blue, .black ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

#if DEBUG
struct ButtonText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonText(text: "Hello World")
    }
}
#endif
