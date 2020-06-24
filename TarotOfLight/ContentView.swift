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
    @State var weAreIn = Pages.mainPage
    @State var tideAnimating = true
    @State var plantFullAnimating = true
    @State var progress = 30.0


    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color: a small shade of grey, filling the whole screen
            // Adding background color for different page
            // FIXME: should consider use more consistent color
            if (weAreIn == Pages.mainPage) {
                Color("LightGray")
            } else if (weAreIn == Pages.cardPage) {
                Color("DarkPurple")
            } else if (weAreIn == Pages.minePage) {
                Color(.blue)
            }
            // Background tidal wave as GIF, we use SDWebImageSwiftUI to load and use GIF

            if (weAreIn == Pages.mainPage) {
                MainPageContentView(tideAnimating: $tideAnimating, progress: $progress)
                    .transition(.fly)
                    .onDisappear() {
//                        print("MainPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = false
//                        self.plantFullAnimating = true
                    }.onAppear() {
//                        print("MainPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.cardPage) {
                CardPageContentView(plantFullAnimating: $plantFullAnimating)
                    .transition(.fly)
                    .onDisappear() {
//                        print("CardPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = true
//                        self.plantFullAnimating = false
                    }.onAppear() {
//                        print("CardPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.minePage) {
                MinePageContentView()
                    .transition(.fly)
                    .onDisappear() {
//                        print("MinePageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = true
//                        self.plantFullAnimating = true
                    }.onAppear() {
//                        print("MinePageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            }


            // The page selector, should remain if we're only navigating around different pages
            // And it should go when the scene is completely changed
            PageSelector(weAreIn: $weAreIn).padding(.bottom, 50)
        }.edgesIgnoringSafeArea(.all)
    }
}



// Using hex directly
// NOT A GOOD PRACTICE
// FIXME: consider adding colors to xcassets
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
                .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

// Previewer
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}
