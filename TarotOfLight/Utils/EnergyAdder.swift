//
//  EnergyAdderView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/29.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

// The energy adder view, basically a button with a circle progress bar
// MARK: We should wrap the view with a bit ZStack and set the ZStack's frame to make the if-else clause work properly
// with the transition defined here.
struct EnergyAdderView: View {
    @EnvironmentObject var profile: LighTarotModel
    var energy = 5.0
    var fontSize: CGFloat = 12
    var circleScale: CGFloat = 1.2
    var strokeColor = Color("Lime")
    var fillColor = Color("LightGray")
    var shouldModify: Bool {
        profile.navigator.weAreInGlobal != .introduction
    }
    @State var shouldAppear: Bool = true

    var body: some View {
        // MARK: Using the GeometryReader to set ZStack's frame to make the center of the scale work
        GeometryReader {
            geo in
            ZStack {
                if shouldAppear
//                    && profile.shouldShowEnergy
                    { // Should have a outer frame
                    Button(action: {
                        print("Triggerd final action!")
                        withAnimation(springAnimation) {
                            if shouldModify { // Don't modify the model if in the introduction page
                                profile.energy += energy
                            }
                            // Make this view disappear
                            shouldAppear = false
                        }
                    }) {
                        ShinyText(text: "+" + String(format: "%0.f", energy) + "能量", font: .SourceHanSansHeavy, size: fontSize)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(fillColor)
                                    Circle()
                                        .stroke(strokeColor, lineWidth: 2)

                                }.scaledToFill()
                                    .scaleEffect(circleScale)
                            )

                    }
                        .buttonStyle(LongPressButtonStyle(color: Color("LightMediumDarkPurple")))
                        .transition(scaleTransition) // Scale combined with fade animation

                }
            }.frame(width: geo.size.width, height: geo.size.height) //MARK: Frame settings
            .onAppear {
                print("Should you appear: \(shouldAppear), should show energy: \(profile.shouldShowEnergy)")
            }
        }
    }
}
