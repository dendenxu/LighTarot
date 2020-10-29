//
//  ShinyBackground.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/25.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
func randomPositionInDoubleRectangle(size: CGSize) -> CGSize {
//    print("We're randomly generating size for bounds: \(size.width), \(size.height)")
    return CGSize(width: 2 * size.width * CGFloat.random(in: 0..<1) - size.width, height: 2 * size.height * CGFloat.random(in: 0..<1) - size.height)
}

func distance(s1: CGSize, s2: CGSize) -> CGFloat {
    return sqrt((s1.width - s2.width) * (s1.width - s2.width) + (s1.height - s2.height) * (s1.height - s2.height))
}

func adjustSize(toAdjust: CGSize, scale: CGFloat = 1.0, offset: CGFloat = 30) -> CGSize {
    return toAdjust * scale + CGSize(width: toAdjust.width / toAdjust.distance * offset, height: toAdjust.height / toAdjust.distance * offset)
//    return toAdjust
}

extension CGSize {
    init(p: CGPoint) {
        self = CGSize(width: p.x, height: p.y)
    }
    static func + (s1: CGSize, s2: CGSize) -> CGSize {
        return CGSize(width: s1.width + s2.width, height: s1.height + s2.height)
    }
    static func * (s: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: s.width * scale, height: s.height * scale)
    }
    static func - (s1: CGSize, s2: CGSize) -> CGSize {
        return CGSize(width: s1.width - s2.width, height: s1.height - s2.height)
    }

    var distance: CGFloat {
        sqrt(self.width * self.width + self.height * self.height)
    }
}

extension CGPoint {
    var distance: CGFloat {
        sqrt(self.x * self.x + self.y * self.y)
    }
}

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

struct TravelingPentagram<Content: View>: View {

    var size: CGSize
    var offsetView: CGSize
    var viewSize: CGFloat
    let selfMaxAngle: Double
    let scale: CGFloat
    var content: Content

//    var imageName = "starstroke"
//    var tintColor = Color.white

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
    static func zerone() -> CGFloat { return CGFloat([-1, 1].randomElement() ?? 1) }
    @State var isAtSelfMaxAngle = false
    @State var isAtTheBottom = false
    let onceZerone = zerone()
    var body: some View {
        content
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

struct ShinyBackground: View {
    var originSize = CGSize(width: .ScreenWidth, height: .ScreenHeight)
    var nStroke = 50
    var nFill = 50
    var size = CGSize(width: .ScreenWidth, height: .ScreenHeight)
    var tintColor = Color.white
    var viewSize: CGFloat = 30
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                ForEach(0..<self.nStroke) { number in
                    ShinyPentagram(
                        originSize: originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: self.size)),
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
                    ShinyPentagram(
                        originSize: originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: self.size)),
                        viewSize: viewSize
                    ) {
                        Image("starfull")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                    }
                }
            }.offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}


struct TravelingBackground: View {
    var nStroke = 50
    var nFill = 50
    var viewSize: CGFloat = 20
    var tintColor = Color("LightMediumDarkPurple")
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                let size = CGSize(width: geometry.size.width - 30, height: geometry.size.height - 30)

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
