//
//  SelectorView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI


struct SelectorView: View {
    @State var weAreIn = Pages.mainPage
    @State var progress = 30.0


    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color: a small shade of grey, filling the whole screen
            // Adding background color for different page
            // FIXME: should consider use more consistent color
            if (weAreIn == Pages.mainPage) {
                Color("LightGray")
            } else if (weAreIn == Pages.cardPage) {
                Color("MediumDarkPurple")
            } else if (weAreIn == Pages.minePage) {
                Color(.blue)
            }
            // Background tidal wave as GIF, we use SDWebImageSwiftUI to load and use GIF

            if (weAreIn == Pages.mainPage) {
                MainPageContentView(progress: $progress)
                    .transition(.fly)
            } else if (weAreIn == Pages.cardPage) {
                CardPageContentView()
                    .transition(.fly)
            } else if (weAreIn == Pages.minePage) {
                MinePageContentView()
                    .transition(.fly)
            }


            // The page selector, should remain if we're only navigating around different pages
            // And it should go when the scene is completely changed
            PageSelector(weAreIn: $weAreIn).padding(.bottom, 50)
        }.edgesIgnoringSafeArea(.all)
    }
}


// The page selector view with slightly tailored edge
struct PageSelector: View {
    @Binding var weAreIn: Pages
    var body: some View {
        HStack {
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.mainPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.cardPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.minePage)
        }
            .padding()
            .background(Color.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

// Buttons in the page selector, using enum to avoid raw string
// which could lead to typo that compiler cannot foresee
struct PageSelectorButton: View {
    @Binding var weAreIn: Pages
    let whoWeAre: Pages
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                self.weAreIn = self.whoWeAre
            }
        }) {
            Image(String(describing: whoWeAre) + ((weAreIn == whoWeAre) ? "Material" : ""))
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .shadow(radius: 10)
        }.padding(.horizontal, 20)
    }
}

// Page changer
enum Pages: CustomStringConvertible {
    var description: String {
        switch self {
        case .mainPage: return "mainPage"
        case .cardPage: return "cardPage"
        case .minePage: return "minePage"
        }
    }

    case mainPage
    case cardPage
    case minePage
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
struct SelectorView_preview: PreviewProvider {
    static var previews: some View {
        SelectorView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}
