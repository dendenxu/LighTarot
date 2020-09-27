//
//  ShinyWord.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct ShinyText: View {
    var text = "解锁新牌阵"
    var font = "Source Han Sans Heavy"
    var size: CGFloat = 12.0
    var maxScale: CGFloat = 1.5
    var textColor = Color("LightPink")
    var shadowColor = Color.white
    var isScaling = false
    @State var isAtMaxScale = false
    var body: some View {
        Text(self.text)
            .font(.custom(self.font, size: self.size))
            .foregroundColor(textColor)
            .shadow(color: self.shadowColor.opacity(self.isAtMaxScale ? 0.8 : 0.5), radius: 10 * (self.isAtMaxScale ? 1 / self.maxScale : self.maxScale))
            .onAppear() {
                withAnimation(shineAnimationOuter) {
                    self.isAtMaxScale.toggle()
                }
        }
    }
}
