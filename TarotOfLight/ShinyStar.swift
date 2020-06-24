//
//  ShinyStar.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

// Some randomized shiny star with shiny animations
struct ShinyStar: View {
    let offset: CGSize
    let scale: CGFloat
    @State var isAtMaxScale = false
    let maxScale: CGFloat = 1.5
    var shineAnimation = Animation
        .easeInOut(duration: 1)
        .repeatForever(autoreverses: true)
        .delay(Double.random(in: 0..<1))
    var body: some View {
        // Note that the declarative statement takes effect one by one
        // For example we can add two rotation effect just by adding the offset before and after the offset change
        Image("star")
            .resizable()
            .scaledToFit()
            .shadow(color: Color.purple, radius: 5)
            .opacity(isAtMaxScale ? 1 : 0)
            .scaleEffect(isAtMaxScale ? maxScale : 0.5)
            .rotationEffect(isAtMaxScale ? .degrees(60) : .degrees(0))
            .onAppear() {
                withAnimation(self.shineAnimation) {
                    self.isAtMaxScale.toggle()
                }
            }
            .frame(width: 30 * scale, height: 30 * scale, alignment: .center)
            .offset(offset)
            .rotationEffect(isAtMaxScale ? .degrees(30) : .degrees(0))
    }
}

struct ShinyStar_Previews: PreviewProvider {
    static var previews: some View {
        ShinyStar(offset: CGSize(width: 20, height: 20), scale: 1.5)
    }
}
