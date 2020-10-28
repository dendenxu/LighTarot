//
//  IntroductionPageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/28.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct IntroPageView: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var currentIndex = 0
    @State var percentatges: [CGFloat] = [0, 1, 2]
    let introductionPageCount = 3
    var body: some View {
        ZStack {
            PagerView(accentColor: .white, overlookColor: .gray, backgroundColor: Color.black.opacity(0.2), currentIndex: $currentIndex, percentages: $percentatges) {
                ForEach(0..<introductionPageCount) { index in
                    InnerIntroduction(percentage: percentatges[index]) {
                        ZStack {
                            // Invisible background to drag
                            // Okay... not working in ZStack
                            // MARK: Don't do this, SwiftUI will optimize out this View with hidden attribute or no color at all
                            // MARK: Using 0.001 to avoid this optimization and make th whole view scrollable, possibly bug...
                            RoundedRectangle(cornerRadius: .ScreenCornerRadius)
                                .foregroundColor(Color("LightGray"))
                                .opacity(0.001)
                                .frame(width: .ScreenWidth, height: .ScreenHeight)
                            VStack(spacing: 30) {
                                Button(action: {
                                    withAnimation(springAnimation) {
                                        profile.weAreInGlobal = .selector
                                    }
                                }) {
                                    VStack {
                                        VStack {
                                            ShinyText(text: "点击牌阵进入AR捕光塔罗", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
                                            ShinyText(text: "进入自我探索与自我治愈的旅程", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
                                        }.padding(.horizontal, 40)
                                            .padding(.vertical, 20)

                                    }.background(
                                        Capsule()
                                            .strokeBorder(
                                                style: StrokeStyle(lineWidth: 2)
                                            )
                                            .foregroundColor(Color("MediumLime"))
                                    )
                                }

                                Spacer().frame(height: 30)

                                Image("diamond")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)

                                VStack {
                                    Image("cardPage")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)

                                    ShinyText(text: "捕光牌阵", font: .SourceHanSansLight, size: 14, textColor: Color("MediumLime"), shadowColor: .white)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct InnerIntroduction<Content: View>: View {
    var percentage: CGFloat
    var content: Content
    let baseOffset: CGFloat = 150 / 414 * .ScreenWidth
    let baseScale: CGFloat = 0.9
    let baseOpacity: CGFloat = 0.25
    let baseTint: CGFloat = 0.6
    init(percentage: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.percentage = percentage
        self.content = content()
    }
    var body: some View {
        let computedScale = (1.0 - abs(percentage)) * (1 - baseScale) + baseScale
        let computedOpacity = Double((1.0 - abs(percentage)) * (1 - baseOpacity) + baseOpacity)
        let computedTint = Double((1.0 - abs(percentage)) * (1 - baseTint) + baseTint)
        let computedTintColor = Color(red: computedTint, green: computedTint, blue: computedTint)
        return content
            .scaleEffect(computedScale, anchor: .center)
            .offset(x: -percentage * baseOffset)
            .opacity(computedOpacity)
            .colorMultiply(computedTintColor)
            .zIndex(-Double(abs(percentage)))
    }
}

struct IntroductionPageView_Previews: PreviewProvider {
    static var previews: some View {
        IntroPageView().edgesIgnoringSafeArea(.all).previewDevice("iPhone 11")
    }
}
