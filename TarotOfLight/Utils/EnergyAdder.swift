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
        profile.weAreInGlobal != .introduction
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

struct LongPressButtonStyle: PrimitiveButtonStyle {
    var color = Color.red // The progress bar color
    var timeToFulfill: Double = 0.3 // The time interval in which the progress bar will be filled
    var timeInterval: Double = 0.001 // The time interval granularity, specifically, the timer's fire rate's reciprocal
    var maxProgress: CGFloat = 1 // Beginning from zero, the value to reach for the progresss variable
    var lineWidth: CGFloat = 25

    // Build the body of the button's label
    // Basically adding background and overlay to the current label's element
    // A Text, a Shape, anything
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        LongPressButton(configuration: configuration, color: color, lineWidth: lineWidth, timeToFulfill: timeToFulfill, timeInterval: timeInterval, maxProgress: maxProgress)
    }

    // The innner structure of LongPressButtonStyle
    struct LongPressButton: View {
        // This modify will set value to default by calling reset function (which is a closure here to act as a callback)
        // We use NotificationCenter to make thins work
        // MARK: This closure cannot capture anything regarding current element, although they do exist in memory at the same time
        @GestureState(
            initialValue: false,
            reset: { value, transaction in
                print("RESET: The value is reset")
                NotificationCenter.default.post(
                    name: NSNotification.LongPressCancel, object: nil)
            }) private var pressed
        @State var timer: Timer?

        // The progress bar control state, every time things get updated, check whether the largest possible amount has been reached
        @State var progress: CGFloat = 0 {
            didSet {
                if progress >= maxProgress {
                    onEndedAction()
                    configuration.trigger()
                }
            }
        }
        let configuration: PrimitiveButtonStyle.Configuration // Argument from outer PrimitiveButtonStyle
        let color: Color // Color of the progress bar
        let lineWidth: CGFloat
        let timeToFulfill: Double
        let timeInterval: Double
        let maxProgress: CGFloat
        var circleAway: CGFloat { lineWidth }
        @State var longPressed = false // The actual value to be updated, so that we can add more animation
        // BUG: Adding withAnimation on the body of updating doesn't seem to work properly

        func onEndedAction() {
            print("onEndedAction function triggerred")
            timer?.invalidate()
            withAnimation(fastSpringAnimation) {
                longPressed = false
            }
            progress = 0
        }

        func onChangedAction() {
            print("onChangedAction function triggerred")
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
            ZStack {
                let longPress = LongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity)
                    .updating($pressed) {
                        value, state, transaction in
                        state = value
                        print("Messy, A night.")
                    }
                    .onChanged { _ in
                        print("CHANGED: Should we start the timer?")
                        onChangedAction()
                }
                configuration.label
                    .foregroundColor(.white)
                    .opacity(longPressed || progress >= maxProgress ? 0.75 : 1.0)
                    .scaleEffect(longPressed || progress >= maxProgress ? 0.75 : 1.0)
                    .background(
                        GeometryReader {
                            geo in
                            ZStack {
                                if longPressed {
                                    CircleProgress(color: color, progress: progress, lineWidth: lineWidth)
                                        .scaledToFill()
//                                        .scaleEffect(2)
                                    .frame(width: geo.size.width + circleAway, height: geo.size.height + circleAway)
                                        .offset(x: -circleAway / 2, y: -circleAway / 2)
                                }
                            }
                        }
                    )

                    .compositingGroup()
                    .shadow(color: Color.black.opacity(0.15), radius: 2)
                    .gesture(longPress)
                    .onReceive(
                        // MARK: Receiving all similar Notification
                        NotificationCenter.default.publisher(for: NSNotification.LongPressCancel)) { obj in
                        onEndedAction()
                }
            }
        }
    }
}

struct CircleProgress: View {
    var color = Color.red
    var progress: CGFloat
    var lineWidth: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .opacity(0.7)
                .foregroundColor(color)
        }
            .rotationEffect(.degrees(-90))
    }
}
