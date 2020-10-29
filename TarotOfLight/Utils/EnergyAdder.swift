//
//  EnergyAdderView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/29.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct EnergyAdderView: View {
    let energy = 5.0
    let fontSize: CGFloat = 12
    let circleScale: CGFloat = 1.2
    let strokeColor = Color("Lime")
    let fillColor = Color("LightGray")
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .ScreenCornerRadius)
                .foregroundColor(.gray)
                .frame(width: .ScreenWidth, height: .ScreenHeight)
            ShinyText(text: "+" + String(format: "%0.f", energy) + "能量", font: .SourceHanSansHeavy, size: fontSize)
                .background(
                    Circle()
                        .fill(fillColor)
                        .scaledToFill()
                        .scaleEffect(circleScale)
                        .overlay(
                            Circle()
                                .stroke(strokeColor, lineWidth: 2)
                                .scaleEffect(circleScale)
                        )

                )
        }
    }
}

struct EnergyAdderView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyAdderView()
            .edgesIgnoringSafeArea(.all)
            .previewDevice("iPhone 11")
    }
}
