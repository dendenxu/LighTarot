//
//  SelectorView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI


struct SelectorView: View {
    @EnvironmentObject var profile: LighTarotModel
    var body: some View {
        ZStack(alignment: .bottom) {
//            if profile.weAreInSelector == .mainPage { Color(profile.energy >= 100.0 ? "MediumDarkPurple" : "LightGray") }
//            else if profile.weAreInSelector == .cardPage { Color("MediumDarkPurple") }
//            else if profile.weAreInSelector == .minePage { Color("LightGray") }
            // Background color: a small shade of grey, filling the whole screen
            // Adding background color for different page
            // We're defining pages after a background color so that they can use different transition when loading
            // The color block sits there without any transition animation to be applied
            if (profile.weAreInSelector == .mainPage) {
                MainPageView(progress: $profile.energy)
                    .frame(width: .ScreenWidth, height: .ScreenHeight)
                    .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                    .transition(.fly)
            } else if (profile.weAreInSelector == .cardPage) {
                CategoryView()
                    .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                    .transition(.fly)
            } else if (profile.weAreInSelector == .minePage) {
                MinePageView()
                    .frame(width: .ScreenWidth, height: .ScreenHeight)
                    .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                    .transition(.fly)
            }

            // A small selector to navigate around our big selector where three subViews exist
            PageSelector().padding(.bottom, 50)
        }

        
        .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
    }
}


// The page selector view with slightly tailored edge
struct PageSelector: View {
    var body: some View {
        HStack {
            PageSelectorButton(whoWeAre: .mainPage)
            PageSelectorButton(whoWeAre: .cardPage)
            PageSelectorButton(whoWeAre: .minePage)
        }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color.white.opacity(0.3))
//                    .shadow(radius: 5)
            )
    }
}

// Buttons in the page selector, using enum to avoid raw string
// which could lead to typo that compiler cannot foresee
struct PageSelectorButton: View {
    @EnvironmentObject var profile: LighTarotModel
    let whoWeAre: SelectorSelection
    var body: some View {
        Button(action: {
            profile.complexSuccess()
            withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                profile.weAreInSelector = whoWeAre
            }
        }) {
            Image(String(describing: whoWeAre) + ((profile.weAreInSelector == whoWeAre) ? "Material" : ""))
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



