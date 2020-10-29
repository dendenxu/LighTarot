//
//  EnergyAdderView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/29.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct EnergyAdderView: View {
    var energy = 5.0
    var fontSize: CGFloat = 12
    var circleScale: CGFloat = 1.2
    var strokeColor = Color("Lime")
    var fillColor = Color("LightGray")
    var body: some View {
        ZStack {
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
