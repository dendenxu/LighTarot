//
//  CardPageContentView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardPageContentView: View {
    @Binding var plantFullAnimating: Bool

    var body: some View {
        // Why do we have to make it inside some stack for it to be loaded?
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
    }
}
