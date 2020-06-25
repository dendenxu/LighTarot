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

struct ShinyPentagram: View {
    var offset: CGSize
    var scale: CGFloat
    var maxAngle = 3600.0
    var size: CGFloat = 30.0
    var imageName = "starstroke"
    var rotationCenter = UnitPoint(x:0.25, y:0.1)
    var shineAnimation = Animation
        .linear(duration: Double.random(in: 45..<120))
//        .repeatForever(autoreverses: true)
    .repeatForever()
//        .delay(Double.random(in: 0..<1))
    @State var isAtMaxScale = false
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(isAtMaxScale ? 1 / scale : scale)
            .rotationEffect(isAtMaxScale ? .degrees(0) : .degrees(maxAngle))
            .position(x: 0, y: 0)
            .offset(x: self.offset.width, y: self.offset.height)
            .rotationEffect(isAtMaxScale ? .degrees(0) : .degrees(maxAngle), anchor: rotationCenter)
            .onAppear {
                withAnimation(self.shineAnimation) {
                    self.isAtMaxScale.toggle()
                }
        }
    }
}

struct ShinyBackground: View {
    var size: CGSize
    var body: some View {
        ZStack {
            ForEach(0..<20) { number in
                ShinyPentagram(
                    offset: randomPositionInRectangle(size: self.size),
                    scale: CGFloat.random(in: 0.9..<1.1),
                    imageName: "starstroke"
                )
            }
            ForEach(0..<20) { number in
                ShinyPentagram(
                    offset: randomPositionInRectangle(size: self.size),
                    scale: CGFloat.random(in: 0.9..<1.1),
                    imageName: "starfull"
                )
            }
        }
    }
}
