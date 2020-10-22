//
//  SelectorView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI


struct SelectorView: View {
    @EnvironmentObject var profile: UserProfile
    @Binding var weAreInSelector: SelectorSelection
    @Binding var weAreInGlobal: GlobalViewSelection
    @Binding var weAreInCategory: CategorySelection
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color: a small shade of grey, filling the whole screen
            // Adding background color for different page
            // FIXME: should consider use more consistent color
            // Background tidal wave as GIF, we use SDWebImageSwiftUI to load and use GIF

            // We're defining pages after a background color so that they can use different transition when loading
            if (weAreInSelector == SelectorSelection.mainPage) {
                Color(profile.energy >= 100.0 ? "MediumDarkPurple" : "LightGray")
                MainPageView(progress: $profile.energy)
                    .transition(.fly)
            } else if (weAreInSelector == SelectorSelection.cardPage) {
                Color("MediumDarkPurple")
                CardPageView(weAreInGlobal: $weAreInGlobal, weAreInCategory: $weAreInCategory)
                    .transition(.fly)
            } else if (weAreInSelector == SelectorSelection.minePage) {
                Color("LightGray")
                MinePageView()
                    .transition(.fly)
            }
            PageSelector(weAreIn: $weAreInSelector).padding(.bottom, 50)
        }.clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
    }
}


// The page selector view with slightly tailored edge
struct PageSelector: View {
    @Binding var weAreIn: SelectorSelection
    var body: some View {
        HStack {
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: SelectorSelection.mainPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: SelectorSelection.cardPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: SelectorSelection.minePage)
        }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(Color.white.opacity(0.3))
//                    .shadow(radius: 5)
            )
    }
}

// Buttons in the page selector, using enum to avoid raw string
// which could lead to typo that compiler cannot foresee
struct PageSelectorButton: View {
    @Binding var weAreIn: SelectorSelection
    let whoWeAre: SelectorSelection
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
enum SelectorSelection: CustomStringConvertible {
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



