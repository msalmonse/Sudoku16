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
    let isDark: Bool
    let width: CGFloat
    let height: CGFloat

    init(
        _ text: String,
        font: Font = .title,
        color: Color = .primary,
        scheme: ColorScheme = .light
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.isDark = scheme == .dark

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
        .background(isDark ? linearDark : linearLight)
        .clipShape(Capsule())
    }
}

fileprivate let hue = 0.54
fileprivate let saturations = [ 0.0, 0.15, 0.20, 0.25, 0.30, 0.30, 0.30, 0.35, 0.40, 0.45, 0.60  ]

fileprivate let linearDark = LinearGradient(
    gradient: Gradient(colors: saturations.map {
            Color(hue: hue, saturation: $0, brightness: 0.67)
        }
    ),
    startPoint: .top,
    endPoint: .bottom
)

fileprivate let linearLight = LinearGradient(
    gradient: Gradient(colors: saturations.map {
            Color(hue: hue, saturation: $0, brightness: 1.0)
        }
    ),
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
