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
    let r = 0.0
    let g = 0.7
    let b = 1.0
    let colors: [Color] = [
        Color(red: r, green: g, blue: b, opacity: 0.05),
        Color(red: r, green: g, blue: b, opacity: 0.20),
        Color(red: r, green: g, blue: b, opacity: 0.25),
        Color(red: r, green: g, blue: b, opacity: 0.30),
        Color(red: r, green: g, blue: b, opacity: 0.30),
        Color(red: r, green: g, blue: b, opacity: 0.30),
        Color(red: r, green: g, blue: b, opacity: 0.30),
        Color(red: r, green: g, blue: b, opacity: 0.30),
        Color(red: r, green: g, blue: b, opacity: 0.35),
        Color(red: r, green: g, blue: b, opacity: 0.50),
    ]
    return LinearGradient(
        gradient: Gradient(colors: colors),
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
