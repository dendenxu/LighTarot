//
//  PredictLightView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

import SDWebImageSwiftUI

struct PredictLightView: View {
    @EnvironmentObject var profile: LighTarotModel
    var body: some View {
        ZStack
        {
            if (profile.weAreIn == .animation) { Color("MediumDarkPurple") }
            else if (profile.weAreIn == .category) { Color("LightMediumDarkPurple") }
            // Why do we have to make it inside some stack for it to be loaded?
            if (profile.weAreIn == .animation) {
                OuterInterpreterView().transition(scaleTransition)
                    .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
            } else if(profile.weAreIn == .category) {
                CardPageView().transition(scaleTransition)
                    .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
            }
        }
//        .frame(width: .ScreenWidth, height: .ScreenHeight)
        .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
    }
}

// CardViewSelector
enum PredictLightViewSelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .animation: return "animation"
        case .category: return "category"
//        case .arCamera: return "arCamera"
        }
    }

    case animation
    case category
//    case arCamera
}
