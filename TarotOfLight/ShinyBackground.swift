//
//  ShinyBackground.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/25.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

func randomPositionInRectangle(size: CGSize) -> CGSize {
//    print("We're randomly generating size for bounds: \(size.width), \(size.height)")
    return CGSize(width: 2 * size.width * CGFloat.random(in: 0..<1) - size.width, height: 2 * size.height * CGFloat.random(in: 0..<1) - size.height)
}

func distance(s1: CGSize, s2: CGSize) -> Double {
    return Double(sqrt((s1.width - s2.width) * (s1.width - s2.width) + (s1.height - s2.height) * (s1.height - s2.height)))
}

func distance(s: CGSize) -> Double {
    return Double(sqrt(s.width * s.width + s.height * s.height))
}

func distance(p: CGPoint) -> Double {
    return Double(sqrt(p.x * p.x + p.y * p.y))
}

func toSize(s: CGSize, u: UnitPoint) -> CGSize {
    return CGSize(width: s.width * u.x, height: s.height * u.y)
}

func adjustSize(s: CGSize, u: UnitPoint, toAdjust: CGSize, scale: CGFloat = 1.0, offset: CGFloat = 10, position: CGPoint = CGPoint(x: 0, y: 0)) -> CGSize {
    let origin = toSize(s: s, u: u) + CGSize(p: position)
    let minus = toAdjust - origin
    return origin + minus * scale + CGSize(width: minus.width / CGFloat(distance(s: minus)) * offset, height: minus.height / CGFloat(distance(s: minus)) * offset)
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
}

struct ShinyPentagram: View {
    var originSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var offset: CGSize
    var scale: CGFloat
    var maxAngle = 720.0
    var selfMaxAngle = 1440.0
    var size: CGFloat = 30.0
    var imageName = "starstroke"
    var rotationCenter = UnitPoint(x: 0.265, y: 0.11)
    var position = CGPoint(x: 0, y: 0)
    var shineAnimation: Animation {
        get {
            Animation
                .linear(duration: 60 / distance(s: originSize) * Double(distance(s1: offset, s2: CGSize(p: position) + toSize(s: originSize, u: rotationCenter))))
                .repeatForever(autoreverses: false)
        }
    }
    var shineAnimationSelf: Animation {
        get {
            Animation
                .linear(duration: 30 * Double.random(in: 0.5..<1))
                .repeatForever(autoreverses: false)
        }
    }


    @State var isAtMaxScale = false
    @State var isAtSelfMaxAngle = false
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(isAtMaxScale ? 1 / scale : scale)
            .rotationEffect(isAtSelfMaxAngle ? .degrees(0) : .degrees(selfMaxAngle))
            .position(x: 0, y: 0)
            .offset(x: self.offset.width, y: self.offset.height)
            .rotationEffect(isAtMaxScale ? .degrees(0) : .degrees(maxAngle), anchor: rotationCenter)
            .onAppear {
                withAnimation(self.shineAnimation) {
                    self.isAtMaxScale.toggle()
                }
                withAnimation(self.shineAnimation) {
                    self.isAtSelfMaxAngle.toggle()
                }
        }
    }
}

struct ShinyBackground: View {
    var originSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//    var rotationCenter = UnitPoint(x: 0.265, y: 0.11)
    var rotationCenter = UnitPoint(x: 0.5, y: 0.5)
    var nStroke = 50
    var nFill = 50
    var size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var position = CGPoint(x: 0, y: 0)
    var body: some View {
        ZStack {
            ForEach(0..<nStroke) { number in
                ShinyPentagram(
                    originSize: self.originSize,
                    offset: adjustSize(s: self.originSize, u: self.rotationCenter, toAdjust: randomPositionInRectangle(size: self.size)),
                    scale: CGFloat.random(in: 0.9..<1.1),
                    imageName: "starstroke",
                    rotationCenter: self.rotationCenter
                )
            }
            ForEach(0..<nFill) { number in
                ShinyPentagram(
                    originSize: self.originSize,
                    offset: adjustSize(s: self.originSize, u: self.rotationCenter, toAdjust: randomPositionInRectangle(size: self.size)),
                    scale: CGFloat.random(in: 0.9..<1.1),
                    imageName: "starfull",
                    rotationCenter: self.rotationCenter
                )
            }
        }
    }
}
