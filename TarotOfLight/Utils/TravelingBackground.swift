//
//  TravelingBackground.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/11/2.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct TravelingBackground: View {
    var nStroke = 50
    var nFill = 50
    var viewSize: CGFloat = 20
    var tintColor = Color("LightMediumDarkPurple")
    var body: some View {
        GeometryReader {
            geo in
            ZStack {
                let size = CGSize(width: geo.size.width - 30, height: geo.size.height - 30)

                ForEach(0..<self.nStroke) { number in
                    TravelingPentagram(
                        size: size,
                        offsetView: randomPositionInDoubleRectangle(size: size),
                        viewSize: viewSize
                    ) {
                        Image("starstroke")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                    }
                }
                ForEach(0..<self.nFill) { number in
                    TravelingPentagram(
                        size: size,
                        offsetView: randomPositionInDoubleRectangle(size: size),
                        viewSize: viewSize
                    ) {
                        Image("starfull")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                    }
                }.onAppear {
                    print("Getting size \(size)")
                }.offset(x: size.width / 2, y: size.height / 2)
            }
        }
    }
}

struct TravelingPentagram<Content: View>: View {

    var size: CGSize
    var offsetView: CGSize
    var viewSize: CGFloat
    let selfMaxAngle: Double
    let scale: CGFloat
    var content: Content

    init(size: CGSize, offsetView: CGSize, viewSize: CGFloat, selfMaxAngle: Double = 1440.0, scale: CGFloat = .random(in: 1..<1.2), @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.selfMaxAngle = selfMaxAngle
        self.scale = scale
        self.offsetView = offsetView
        self.viewSize = viewSize
        self.size = size
    }


    var shineAnimationSelf: Animation {
        Animation
            .linear(duration: 30 * Double.random(in: 0.5..<1))
            .repeatForever(autoreverses: true)
    }
    var travelingAnimation: Animation {
        Animation
            .linear(duration: 15 * Double.random(in: 0.5..<1))
            .repeatForever(autoreverses: true)
    }
    // Randomly determining the traveling direction
    @State var isAtSelfMaxAngle = false
    @State var isAtTheBottom = false
    let onceZerone = CGFloat([-1, 1].randomElement() ?? 1)
    var body: some View {
        content
            .scaledToFit()
            .frame(width: viewSize, height: viewSize)
            .scaleEffect(isAtSelfMaxAngle ? 1 / scale : scale)
            .rotationEffect(isAtSelfMaxAngle ? .degrees(0) : .degrees(selfMaxAngle))
            .position(x: 0, y: 0)
            .offset(x: offsetView.width, y: offsetView.height)
            .offset(y: (isAtTheBottom ? onceZerone : -onceZerone) * .ScreenHeight)
            .onAppear {
                withAnimation(shineAnimationSelf) {
                    isAtSelfMaxAngle.toggle()
                }
                withAnimation(travelingAnimation) {
                    isAtTheBottom.toggle()
                    print("Animation started")
                }
        }
    }
}
