//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

// FIXME: format stuff
import SwiftUI
import UIKit

struct ContentView: View {
    @State var weAreIn = GlobalViewSelection.selector

    var body: some View {
        ZStack(alignment: .bottom) {
            if (weAreIn == .selector) {
                SelectorView()
                    .transition(.fly)
            } else if (weAreIn == .predictLight) {
                PredictLightView()
                    .transition(.fly)
//                Spacer()
            }
        }
        // FIXME: when using if to select between two global view, we'll get strange animation for MainPageContentView
        // Well, strangely we're able to fix this by adding a frame width limitation on MainPageContenView
        // SelectorView()
    }
}

// Page changer
enum GlobalViewSelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .selector: return "selector"
        case .predictLight: return "predictLight"
        }
    }

    case selector
    case predictLight
}

// Previewer
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}
