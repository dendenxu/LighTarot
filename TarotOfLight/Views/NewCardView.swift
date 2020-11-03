//
//  NewCardView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/11/2.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct NewCardView: View {
    @EnvironmentObject var profile: LighTarotModel
    var globalScale: CGFloat = 1
    var shapeShift: CGFloat = 1
    var borderScale: CGFloat = 1
    @State var atMaxAngle: Bool = false
    let isFull: Bool = false
    let plantRadius: CGFloat = 350 / 414 * .ScreenWidth
    let imageWidth: CGFloat = 60 / 414 * .ScreenWidth
    let fontSize: CGFloat = 20
    let smallFontSize: CGFloat = 14


    @State var circleBounceAtMax = false

    var body: some View {
        ZStack(alignment: .top) {
            Color("LightMediumDarkPurple").opacity(0.8)
            ZStack(alignment: .center) {
                VStack {
                    HStack(spacing: 0) {
                        ShinyText(text: "解锁", font: .DefaultChineseFont, size: fontSize, textColor: Color("LightPurple"), shadowColor: Color.gray.opacity(0.3))
                        ShinyText(text: "恋人金字塔", font: .DefaultChineseFont, size: fontSize, textColor: Color("MediumLime"), shadowColor: Color.gray.opacity(0.3))
                        ShinyText(text: "排阵！", font: .DefaultChineseFont, size: fontSize, textColor: Color("LightPurple"), shadowColor: Color.gray.opacity(0.3))
                    }
                    ShinyText(text: "点击屏幕中央，查看新牌阵", font: .DefaultChineseFont, size: smallFontSize, textColor: .white)
                }
                    .offset(y: -plantRadius / 5 * 3)

                Button(action: {
                    withAnimation(springAnimation) {
                        profile.shouldShowNewCardView = false
                        profile.weAreInSelector = .cardPage
                        profile.weAreInGlobal = .predictLight
                        profile.weAreIn = .category
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("MediumPink"))
                            .rotationEffect(atMaxAngle ? .degrees(360) : .degrees(0))
                            .onAppear {
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                    atMaxAngle.toggle()
                                }
                        }
                        Circle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [4, 8]))
                            .foregroundColor(Color("MediumLime"))

                        Image("Polygon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("MediumLime"))
                            .scaleEffect(0.9)

                        VStack(spacing: 15) {
                            Image.default("cardBackV")
                                .frame(width: imageWidth)
                            HStack(spacing: 20) {
                                Image.default("cardBackV")
                                    .frame(width: imageWidth)
                                Image.default("cardBackV")
                                    .frame(width: imageWidth)
                                Image.default("cardBackV")
                                    .frame(width: imageWidth)
                            }
                        }
                    } // Inner ZStack
                    .scaleEffect(circleBounceAtMax ? 1 : 0.9)
                        .onAppear {
                            withAnimation(shineAnimationConstant.repeatForever(autoreverses: true).speed(0.5)) {
                                print("Hello")
                                circleBounceAtMax.toggle()
                            }
                    }
                } // Button
//                .buttonStyle(ShrinkButtonStyle())
            } // Outer ZStack
            .frame(width: plantRadius, height: plantRadius)
                .padding(.top, 233)
        }
    }
}


struct ShrinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
