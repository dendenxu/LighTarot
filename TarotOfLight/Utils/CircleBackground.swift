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
                if (isFull) {
                    Rectangle()
                        .foregroundColor(Color(shadeColor))
//                        .frame(width: geometry.size.width * self.globalScale, height: geometry.size.width * self.globalScale * 2)
                        .scaleEffect(x: globalScale * 2, y: globalScale, anchor: .center)
                        .rotationEffect(.degrees(-45))
                        .offset(x: geometry.size.width * globalScale * sqrt(2) / 2, y: -geometry.size.width * globalScale * sqrt(2) / 2)
                }

                Ellipse()
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [2]
                        )
                    )
                    .foregroundColor(Color(outerColor))
                    .frame(width: geometry.size.width * borderScale * globalScale * (isCircleBorder ? shapeShift : 1), height: geometry.size.width * globalScale * borderScale / (isCircleBorder ? shapeShift : 1))
                    .rotationEffect(isAtMaxScaleOuter ? .degrees(720) : .degrees(0))
                    .onAppear() {
                        withAnimation(shineAnimationOuter) {
                            if (isCircleBorder) {
                                isAtMaxScaleOuter.toggle()
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
                        .foregroundColor(Color(innerColor))
                        .frame(width: geometry.size.width * globalScale / shapeShift, height: geometry.size.width * globalScale / shapeShift)
                        .rotationEffect(isAtMaxScaleInner ? .degrees(360) : .degrees(0))
                        .onAppear() {
                            withAnimation(shineAnimationInner) {
                                isAtMaxScaleInner.toggle()
                            }
                    }
                } else {
                    Ellipse()
                        .fill(Color(innerColor))
                        .frame(width: geometry.size.width * globalScale, height: geometry.size.width * globalScale)
                }
            }
        }
    }
}
