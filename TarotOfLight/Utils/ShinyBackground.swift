//
//  ShinyBackground.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/25.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct ShinyPentagram<Content: View>: View {
    var originSize = CGSize(width: .ScreenWidth, height: .ScreenHeight)
    var offsetView: CGSize
    var viewSize: CGFloat
    var scale: CGFloat
    var maxAngle: Double
    var selfMaxAngle: Double
    var content: Content

    init(originSize: CGSize, offsetView: CGSize, viewSize: CGFloat, scale: CGFloat = CGFloat.random(in: 1..<1.2), maxAngle: Double = 360.0, selfMaxAngle: Double = 1440.0, @ViewBuilder content: @escaping () -> Content) {
        self.originSize = originSize
        self.offsetView = offsetView
        self.viewSize = viewSize
        self.scale = scale
        self.maxAngle = maxAngle
        self.selfMaxAngle = selfMaxAngle
        self.content = content()
    }

    var shineAnimation: Animation {
        get {
            Animation
                .linear(duration: 30 * Double(distance(s1: offsetView, s2: CGSize(width: 0, height: 0)) / originSize.distance))
                .repeatForever(autoreverses: false)
        }
    }
    var shineAnimationSelf: Animation {
        get {
            Animation
                .linear(duration: 30 * Double.random(in: 0.5..<1))
                .repeatForever(autoreverses: true)
        }
    }


    @State var isAtMaxScale = false
    @State var isAtSelfMaxAngle = false
    var body: some View {
        content
            .scaledToFit()
            .frame(width: viewSize, height: viewSize)
            .scaleEffect(isAtSelfMaxAngle ? 1 / scale : scale)
            .rotationEffect(isAtSelfMaxAngle ? .degrees(0) : .degrees(selfMaxAngle))
            .position(x: 0, y: 0)
            .offset(x: offsetView.width, y: offsetView.height)
            .rotationEffect(isAtMaxScale ? .degrees(0) : .degrees(maxAngle), anchor: .topLeading)
            .onAppear {
                withAnimation(shineAnimation) {
                    isAtMaxScale.toggle()
                }
                withAnimation(shineAnimationSelf) {
                    isAtSelfMaxAngle.toggle()
                }
        }

    }
}


struct ShinyBackground: View {
    var originSize = CGSize(width: .ScreenWidth, height: .ScreenHeight)
    var nStroke = 50
    var nFill = 50
    var size = CGSize(width: .ScreenWidth, height: .ScreenHeight)
    var tintColor = Color.white
    var viewSize: CGFloat = 30
    var body: some View {
        GeometryReader {
            geo in
            ZStack {
                ForEach(0..<nStroke) { _ in
                    ShinyPentagram(
                        originSize: originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: size)),
                        viewSize: viewSize
                    ) {
                        Image("starstroke")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                    }
                }
                ForEach(0..<nFill) { _ in
                    ShinyPentagram(
                        originSize: originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: size)),
                        viewSize: viewSize
                    ) {
                        Image("starfull")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                    }
                }
            }.offset(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}
