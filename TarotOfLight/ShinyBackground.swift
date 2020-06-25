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

func distance(s: CGSize) -> CGFloat {
    return sqrt(s.width * s.width + s.height * s.height)
}

func distance(p: CGPoint) -> CGFloat {
    return sqrt(p.x * p.x + p.y * p.y)
}

func adjustSize(toAdjust: CGSize, scale: CGFloat = 1.0, offset: CGFloat = 30) -> CGSize {
    return toAdjust * scale + CGSize(width: toAdjust.width / distance(s: toAdjust) * offset, height: toAdjust.height / distance(s: toAdjust) * offset)
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
    var offsetView: CGSize
    var scale = CGFloat.random(in: 1..<2)
    var maxAngle = 360.0
    var selfMaxAngle = 1440.0
    var viewSize: CGFloat = 3.0
    var imageName = "starstroke"
    var shineAnimation: Animation {
        get {
            Animation
                .linear(duration: 30 * Double(distance(s1: offsetView, s2: CGSize(width: 0, height: 0)) / distance(s: originSize)))
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
            .frame(width: viewSize, height: viewSize)
            .scaleEffect(isAtSelfMaxAngle ? 1 / scale : scale)
            .rotationEffect(isAtSelfMaxAngle ? .degrees(0) : .degrees(selfMaxAngle))
            .position(x: 0, y: 0)
            .offset(x: self.offsetView.width, y: self.offsetView.height)
            .rotationEffect(isAtMaxScale ? .degrees(0) : .degrees(maxAngle), anchor: .topLeading)
            .onAppear {
                withAnimation(self.shineAnimation) {
                    self.isAtMaxScale.toggle()
                }
                withAnimation(self.shineAnimationSelf) {
                    self.isAtSelfMaxAngle.toggle()
                }
        }
    }
}

struct ShinyBackground: View {
    @State var originSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var nStroke = 50
    var nFill = 50
    var size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                ForEach(0..<self.nStroke) { number in
                    ShinyPentagram(
                        originSize: self.originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: self.size)),
                        imageName: "starstroke"
                    )
                }
                ForEach(0..<self.nFill) { number in
                    ShinyPentagram(
                        originSize: self.originSize,
                        offsetView: adjustSize(toAdjust: randomPositionInDoubleRectangle(size: self.size)),
                        imageName: "starfull"
                    )
                }
            }.offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
