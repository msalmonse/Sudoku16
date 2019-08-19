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
    let font: Font
    let color: Color
    let width: CGFloat
    let height: CGFloat

    init(_ text: String, font: Font = .title, color: Color = .primary) {
        self.text = text
        self.font = font
        self.color = color

        switch font {
        case .headline: width = 100; height = 35
        case .body:     width = 100; height = 30
        default:        width = 150; height = 50
        }
    }

    var body: some View {
        Text(text)
        .font(font)
        .foregroundColor(color)
        .padding()
        .frame(width: width, height: height)
        .overlay(strokedCapsule())
        .background(linearBackgroupd)
        .clipShape(Capsule())
    }
}

fileprivate let r = 0.00
fileprivate let g = 0.75
fileprivate let b = 1.00
fileprivate let colors: [Color] = [
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
fileprivate let linearBackgroupd = LinearGradient(
    gradient: Gradient(colors: colors),
    startPoint: .top,
    endPoint: .bottom
)

#if DEBUG
struct ButtonText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonText("Hello World")
    }
}
#endif
