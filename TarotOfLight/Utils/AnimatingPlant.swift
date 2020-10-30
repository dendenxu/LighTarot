//
//  AnimatingPlant.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/29.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct AnimatingPlant: View {
    let isFull: Bool
    var onMe: Bool = true
    @Binding var grownAnimating: Bool
    var globalScale: CGFloat = 0.95
    var shapeShift: CGFloat = 1.03
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let plantRadius = min(geo.size.width, geo.size.height)

                ComplexCircleBackground(globalScale: globalScale, shapeShift: shapeShift, isFull: isFull)
                    .frame(width: plantRadius, height: plantRadius)
                ForEach(0..<5) { number in
                    ShinyStar(
                        offset: randomPositionAroundCircle(
                            size: CGSize(
                                width: plantRadius / 2,
                                height: plantRadius / 2)),
                        scale: CGFloat.random(in: 0.9..<1.1)
                    )
                }
                WebImage.default(
                    url: URL(fileURLWithPath: Bundle.main.path(forResource: "grown", ofType: "gif") ?? "grown.gif"),
                    isAnimating: $grownAnimating)
                    .frame(width: plantRadius, height: plantRadius)
                    .scaleEffect(1.2)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10)
                    .mask(
                        ZStack(alignment: .center) {
                            Rectangle().frame(width: .ScreenWidth, height: .ScreenHeight)
                                .offset(y: -.ScreenHeight / 2)
                            Capsule()
                                .frame(width: plantRadius, height: plantRadius * 2)
                                .scaleEffect(globalScale, anchor: .center)
                                .offset(y: -plantRadius / 2)
                        }
                    )
                if onMe {
                    SomePoppingEnergy(onMe: onMe)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .onAppear {
                            print("Some popping energy is here! onMe: \(onMe)")
                    }
//                        .transition(scaleTransition)
                }
            }
        }
    }
}
