//
//  NewCardView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/11/2.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct NewCardView: View {
    var globalScale: CGFloat = 1
    var shapeShift: CGFloat = 1
    var borderScale: CGFloat = 1
    @State var atMaxAngle: Bool = false
    let isFull: Bool = false
    let plantRadius: CGFloat = 350 / 414 * .ScreenWidth
    let imageWidth: CGFloat = 60 / 414 * .ScreenWidth
    let fontSize: CGFloat = 16
    var body: some View {
        ZStack {
            Color("LightMediumDarkPurple").scaledToFill()

            VStack {
                HStack(spacing: 0) {
                    ShinyText(text: "解锁", font: .DefaultChineseFont, size: fontSize, textColor: Color("LightPurple"), shadowColor: Color.gray.opacity(0.3))
                    ShinyText(text: "恋人金字塔", font: .DefaultChineseFont, size: fontSize, textColor: Color("MediumLime"), shadowColor: Color.gray.opacity(0.3))
                    ShinyText(text: "排阵", font: .DefaultChineseFont, size: fontSize, textColor: Color("LightPurple"), shadowColor: Color.gray.opacity(0.3))
                }

                ShinyText(text: "点击屏幕，查看新牌阵", font: .DefaultChineseFont, size: 10, textColor: .white)

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
                        //                Image("cardBackV")
                        HStack(spacing: 20) {
                            Image.default("cardBackV")
                                .frame(width: imageWidth)
                            Image.default("cardBackV")
                                .frame(width: imageWidth)
                            Image.default("cardBackV")
                                .frame(width: imageWidth)
                        }
                    }
                }.frame(width: plantRadius, height: plantRadius)

            }
        }



    }
}

struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardView()
            .previewDevice("iPhone 11")
    }
}
