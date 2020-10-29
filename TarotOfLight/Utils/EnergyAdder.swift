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
    @State var shouldAppear = true

    var body: some View {
        ZStack {
            if shouldAppear {
                Button(action: {
                    print("Triggerd final action!")

                    withAnimation(springAnimation) {
                        if shouldModify {
                            profile.energy += energy
                        }
                        shouldAppear = false
                    }
                }) {
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
                    .buttonStyle(LongPressButtonStyle(color: Color("LightMediumDarkPurple")))
                    .transition(scaleTransition)
            }
        }
    }
}

extension NSNotification {
    static let LongPressCancel = NSNotification.Name.init("LongPressCancel")
}

struct LongPressButtonStyle: PrimitiveButtonStyle {
    var color = Color.red

    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        LongPressButton(configuration: configuration, color: color)
    }



    struct LongPressButton: View {
        @GestureState(
            initialValue: false,
            reset: { value, transaction in
                print("RESET: The value is reset")
                NotificationCenter.default.post(
                    name: NSNotification.LongPressCancel,
                    object: nil, userInfo: ["info": "Test"])
            }) private var pressed
        @State var timer: Timer?
        @State var progress: CGFloat = 0 {
            didSet {
                if progress >= maxProgress {
                    onEndedAction()
                    configuration.trigger()
                }
            }
        }
        let configuration: PrimitiveButtonStyle.Configuration
        var color = Color.red
        let timeToFulfill: Double = 0.3
        let timeInterval: Double = 0.01
        let maxProgress: CGFloat = 1
        @State var longPressed = false

        func onEndedAction() {
            print("Timer is invalidated by tap gesture")
            timer?.invalidate()
            withAnimation(fastSpringAnimation) {
                longPressed = false
            }
            progress = 0
        }

        func onChangedAction() {
            withAnimation(fastSpringAnimation) {
                longPressed = true
            }
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
                print("Timer is triggered, progress: \(progress)")
                withAnimation(fastSpringAnimation) {
                    progress += maxProgress / CGFloat(timeToFulfill / timeInterval)
                }
            }
            print("Timer is started")
        }

        var body: some View {
            GeometryReader {
                geo in
                return ZStack {

                    let longPress = LongPressGesture(minimumDuration: timeToFulfill + 0.1, maximumDistance: .infinity)
                        .updating($pressed) {
                            value, state, transaction in
                            state = value
                            print("Messy, A night.")
                        }
                        .onChanged { _ in
                            print("CHANGED: Should we start the timer?")
                            onChangedAction()
                        }
                        .onEnded { _ in
                            print("END: Timer is invalidated")
                            onEndedAction()
                    }



                    configuration.label
                        .foregroundColor(.white)
                        .opacity(longPressed || progress >= maxProgress ? 0.75 : 1.0)
                        .background(
                            ZStack {
                                if longPressed {
                                    CircleProgress(color: color, progress: progress)
                                        .scaledToFill()
                                        .scaleEffect(2)
                                }
                            }
                        )

                        .compositingGroup()
                        .shadow(color: Color.black.opacity(0.15), radius: 2)
                        .gesture(longPress)
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.LongPressCancel)) { obj in
                            onEndedAction()
                    }
                }
            }
        }
    }
}

struct CircleProgress: View {
    var color = Color.red
    var progress: CGFloat
    var body: some View {
        GeometryReader {
            geo in
            ZStack {
                Circle()
                    .stroke(lineWidth: 12.5)
                    .opacity(0.3)
                    .foregroundColor(color)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 12.5, lineCap: .round, lineJoin: .round))
                    .opacity(0.7)
                    .foregroundColor(color)
            }
                .rotationEffect(.degrees(-90))
                .onAppear {
                    print("Why are you just getting a small number of width and height: \(geo.size.width), \(geo.size.height)")
            }
        }
    }
}
