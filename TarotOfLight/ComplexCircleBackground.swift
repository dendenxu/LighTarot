//
//  ComplexCircleBackground.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

// Complex background, you know we should consider usingg ZStack in this situation
// We've only created this so that we can hold scales as variables
// Should be more configurable if it's to remain
struct ComplexCircleBackground: View {
    var globalScale: CGFloat = 0.95
    var borderScale: CGFloat = 1.05
    var shapeShift: CGFloat = 1.03
    var isCircleBorder = false
    var innerColor = "Lime"
    var outerColor = "LightPurple"
    var shadeColor = "DarkLime"
    var isFull: Bool
    @State var isAtMaxScaleInner = false
    @State var isAtMaxScaleOuter = false
    @State var isToggled = false

    @State var toggleCount = 0

    var randID = Double.random(in: 0..<1)
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if (self.isFull) {
                    Rectangle()
                        .foregroundColor(Color(self.shadeColor))
//                        .frame(width: geometry.size.width * self.globalScale, height: geometry.size.width * self.globalScale * 2)
                        .scaleEffect(x: self.globalScale * 2, y: self.globalScale, anchor: .center)
                        .rotationEffect(.degrees(-45))
                        .offset(x: geometry.size.width * self.globalScale * sqrt(2) / 2, y: -geometry.size.width * self.globalScale * sqrt(2) / 2)
                }

                Ellipse()
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [2]
                        )
                    )
                    .foregroundColor(Color(self.outerColor))
                    .frame(width: geometry.size.width * self.borderScale * self.globalScale * (self.isCircleBorder ? self.shapeShift : 1), height: geometry.size.width * self.globalScale * self.borderScale / (self.isCircleBorder ? self.shapeShift : 1))
                    .rotationEffect(self.isAtMaxScaleOuter ? .degrees(720) : .degrees(0))
                    .onAppear() {
                        withAnimation(shineAnimationOuter) {
                            // Should we just use isAtMaxScaleOuter?
                            // FIXME: myth...
                            // ? Why isn't this working?
                            // ? Why is on appear of this small background called multiple times?
                            // ? By who??
                            // ! I'm literally feeling cheated by this...
                            if (self.isCircleBorder) {
                                self.isAtMaxScaleOuter.toggle()
                            }
                        }

                }


                if (self.isCircleBorder) {
                    Ellipse()
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [2]
                            )
                        )
                        .foregroundColor(Color(self.innerColor))
                        .frame(width: geometry.size.width * self.globalScale * self.shapeShift, height: geometry.size.width * self.globalScale / self.shapeShift)
                        .rotationEffect(self.isAtMaxScaleInner ? .degrees(360) : .degrees(0))
                        .onAppear() {
                            withAnimation(shineAnimationInner) {
                                self.isAtMaxScaleInner.toggle()
                            }
                    }
                } else {
                    Ellipse()
                        .fill(Color(self.innerColor))
                        .frame(width: geometry.size.width * self.globalScale, height: geometry.size.width * self.globalScale)
                }
            }
        }
    }
}

