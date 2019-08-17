//
//  Settings.swift
//  Sudoku16
//
//  Created by Michael Salmon on 2019-08-14.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let initiallySolvedRange = 50.0...200.0
fileprivate let initiallySolvedMin = String(format: "%.0f", initiallySolvedRange.lowerBound)
fileprivate let initiallySolvedMax = String(format: "%.0f", initiallySolvedRange.upperBound)

struct Settings: View {
    @ObservedObject var settings = UserSettings()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    func initialCount() -> String {
        let count = Int(settings.initiallySolved.rounded())
        return "\(count) initially solved squares"
    }
    
    func easeColor(_ ease: Double) -> Color {
        switch ease {
        case 50...90:   return .red
        case 91...120:  return .orange
        case 121...150: return .yellow
        case 151...180: return .green
        case 181...200: return .blue
        default:        return .clear
        }
    }

    var body: some View {
        VStack {
            Text("User Settings")
            .font(.title)
            Spacer()
            
            Toggle("Show wrong solutions?", isOn: $settings.showWrongValues)
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 10))
            
            Toggle("Autofill cells?", isOn: $settings.autofill)
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 10))

            VStack(alignment: .center) {
                HStack(spacing: 1) {
                    Text(initiallySolvedMin)
                    Slider(
                        value: $settings.initiallySolved,
                        in: initiallySolvedRange,
                        step: 1.0
                    )
                    .accentColor(easeColor(settings.initiallySolved))
                    Text(initiallySolvedMax)
                }
                Text(initialCount())
            }
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 10))

            VStack(alignment: .center) {
                Text("Statistics").font(.title)
                .padding(10)

                HStack {
                    Text("Puzzles solved:")
                    Spacer()
                    Text("\(settings.statSolved)")
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Errors made:")
                    Spacer()
                    Text("\(settings.statErrors)")
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Hints taken:")
                    Spacer()
                    Text("\(settings.statHints)")
                    .multilineTextAlignment(.trailing)
                }

                Button(
                    action: {
                        self.settings.statErrors = 0
                        self.settings.statHints = 0
                        self.settings.statSolved = 0
                    },
                    label: { Text("Clear").font(.headline) }
                )
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .overlay(strokedCapsule())
                .padding(10)
            }
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 10))

            Spacer()
            Button(
                action: { self.mode.value.dismiss() },
                label: {
                    ButtonText(text: "Dismiss")
                }
            )
            Spacer()
        }
        .frame(width: 256)
    }
}

#if DEBUG
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
#endif
