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
    @GestureState var isLongPressed = false
    @State private var counter: Int
    @State private var timer: Timer?
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
                        LongPressGesture(minimumDuration: 1)
                            .updating($isLongPressed) { currentState, gestureState, transaction in
                                print("Updating, getting state: \(currentState)")
                                gestureState = currentState
                            }
                            .onChanged { _ in
                                print("Changing, setting shouldScale to: \(shouldScale)")
                                withAnimation(fastSpringAnimation) {
                                    shouldScale = true
                                }
                            }.onEnded { tapped in
                                print("Ended: \(tapped)")
//                                withAnimation(fastSpringAnimation) {
//                                    shouldScale = false
//                                    shouldDisappear = true
//                                }
                                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                    counter += 1
                                })
//                                withAnimation(fastSpringAnimation) {
//                                    shouldScale = false
//                                    if shouldModify { profile.energy += energy }
//                                    shouldDisappear = true
//                                }
                        }
//                            .sequenced(before: TapGesture()
//                                .onEnded { tapped in
//                                    print("Tap press gesture ended: \(tapped)")
//                                    withAnimation(fastSpringAnimation) {
//                                        shouldScale = false
//                                        if shouldModify { profile.energy += energy }
//                                        shouldDisappear = true
//                                    }
//                            })
                    )
            }
        }
    }
}
