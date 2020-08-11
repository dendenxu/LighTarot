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
    @State var weAreInGlobal: GlobalViewSelection = .selector
    @State var weAreInCategory: CategorySelection = .love
    @State var weAreInSelector: SelectorSelection = .mainPage
    var body: some View {
        ZStack(alignment: .bottom) {
            if (weAreInGlobal == .selector) {
                SelectorView(weAreInSelector: $weAreInSelector, weAreInGlobal: $weAreInGlobal, weAreInCategory: $weAreInCategory)
                    .transition(.scale(scale: 0.001))
//                .transition(.fade)
            } else if (weAreInGlobal == .predictLight) {
                PredictLightView(weAreInGlobal: $weAreInGlobal, weAreInCategory: $weAreInCategory)
                    .transition(.scale(scale: 0.001))
//                .transition(.fade)
            }
        }.edgesIgnoringSafeArea(.all)
        // FIXME: when using if to select between two global view, we'll get strange animation for MainPageContentView
        // Well, strangely we're able to fix this by adding a frame width limitation on MainPageContenView
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
