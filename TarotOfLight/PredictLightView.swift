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
    @State var weAreIn = PredictLightViewSelection.animation
    @State var plantFullAnimating: Bool = true

    var body: some View {
        ZStack
        {
            // Why do we have to make it inside some stack for it to be loaded?
            if (weAreIn == .animation) {
                ZStack {
                    Color("DarkPurple").clipShape(RoundedRectangle(cornerRadius: 38))
                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plantfull", ofType: "gif") ?? "plantfull.gif"),
                        isAnimating: self.$plantFullAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 38))

                }
            } else if(weAreIn == .category) {
                Spacer()
            } else if(weAreIn == .arCamera) {
                Spacer()
            }
        }
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