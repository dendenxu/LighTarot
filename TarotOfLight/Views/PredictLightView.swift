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
    @EnvironmentObject var profile: UserProfile
    var body: some View {
        ZStack
        {
            // Why do we have to make it inside some stack for it to be loaded?
            if (profile.weAreIn == .animation) {
                Color("MediumDarkPurple").clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                OuterInterpreterView().transition(.scale(scale: 0.001))
            } else if(profile.weAreIn == .category) {
                Color("LightMediumDarkPurple").clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                CategoryView().transition(.scale(scale: 0.001))
            }
//        }.edgesIgnoringSafeArea(.all)
        }.clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
    }
}

// CardViewSelector
enum PredictLightViewSelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .animation: return "animation"
        case .category: return "category"
        case .arCamera: return "arCamera"
        }
    }

    case animation
    case category
    case arCamera
}
