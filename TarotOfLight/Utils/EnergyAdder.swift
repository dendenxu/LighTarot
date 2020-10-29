//
//  EnergyAdderView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/29.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct EnergyAdderView: View {
    @EnvironmentObject var profile: LighTarotModel
    var energy = 5.0
    var fontSize: CGFloat = 12
    var circleScale: CGFloat = 1.2
    var strokeColor = Color("Lime")
    var fillColor = Color("LightGray")
    var shouldModify: Bool {
        profile.weAreInGlobal != .introduction
    }
    @State var shouldDisappear = false
    @State var shouldScale = false
    @GestureState var point = CGPoint()
    var body: some View {
        ZStack {
            if !shouldDisappear {
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
                    .scaleEffect(shouldScale ? 1.2 : 1)
                    .transition(scaleTransition)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.001)
                            .onEnded {
                                thePoint in
                                withAnimation(fastSpringAnimation) {
                                    shouldScale = true
                                }
                                print("Long press gesture changed: \(thePoint)")
                            }.sequenced(before: TapGesture()
                                .onEnded { thePoint in
                                    print("Tap press gesture ended: \(thePoint)")
                                    withAnimation(fastSpringAnimation) {
                                        shouldScale = false
                                        if shouldModify { profile.energy += energy }
                                        shouldDisappear = true
                                    }
                            })
                    )
            }
        }
    }
}
