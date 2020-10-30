//
//  IntroductionPageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/28.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

var fullScreenBG: some View =
    RoundedRectangle(cornerRadius: .ScreenCornerRadius)
    .foregroundColor(Color("LightGray"))
    .opacity(0.001)
    .frame(width: .ScreenWidth, height: .ScreenHeight)
    .scaleEffect(2)


struct ThirdIntroPage: View {
    var onMe: Bool = true
    @EnvironmentObject var profile: LighTarotModel
    let plantRadius = 250 / 414 * .ScreenWidth
    var body: some View {
        ZStack {
            fullScreenBG
            VStack(spacing: 30) {
                Button(action: {
                    withAnimation(springAnimation) {
                        profile.weAreInGlobal = .selector
                    }
                }) {
                    VStack {
                        VStack {
                            ShinyText(text: "收集捕光能量解锁下一个新牌阵", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
                            ShinyText(text: "丰富神秘的塔罗世界正等待开启", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
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

                AnimatingPlant(isFull: false, onMe: onMe, grownAnimating: .constant(true)).frame(width: plantRadius, height: plantRadius)

                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(springAnimation) {
                            profile.proficientUser = true
                            profile.weAreInGlobal = .selector
                            profile.weAreInSelector = .mainPage
                        }

                    }) {
                        Image.default("power")
                            .frame(width: 30, height: 30)
                            .shadow(radius: 2)
                    }.buttonStyle(LongPressButtonStyle(color: .red))


                    LittleProgressBar(value: 100)
                        .frame(width: 150, height: 25)
                        .padding()
                        .offset(x: -10)
                }
            }
        }
    }
}
struct SecondIntroPage: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var isCardRotateAnimating = true

    var body: some View {
        ZStack {
            fullScreenBG
            VStack(spacing: 30) {
                ZStack {
                    Image
                        .default("scene")
                        .frame(width: 350, height: 350)
                    WebImage
                        .default(
                            url: URL(fileURLWithPath: Bundle.main.path(forResource: "cardsRotation.gif", ofType: "") ?? "cardsRotation.gif"),
                            isAnimating: $isCardRotateAnimating
                        )
                        .frame(width: 175, height: 175)
                        .colorMultiply(Color(hex: 0xcccccc))
                        .rotation3DEffect(.degrees(20), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
                        .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
                        .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1), perspective: 0.5)
                        .offset(x: 20, y: 20)
                }.compositingGroup()


                Spacer().frame(height: 30)

                Button(action: {
                    withAnimation(springAnimation) {
                        profile.weAreInGlobal = .selector
                    }
                }) {
                    VStack {
                        VStack {
                            ShinyText(text: "\"捕捉光\"开启AR塔罗世界", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
                            ShinyText(text: "在时间和光的交汇点，遇见自我", font: .SourceHanSansHeavy, size: 16, textColor: Color("MediumLime"), shadowColor: .white)
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
            }
        }
    }
}

struct FirstIntroPage: View {
    @EnvironmentObject var profile: LighTarotModel
    var body: some View {
        ZStack {
            // Invisible background to drag
            // Okay... not working in ZStack
            // MARK: Don't do this, SwiftUI will optimize out this View with hidden attribute or no color at all
            // MARK: Using 0.001 to avoid this optimization and make th whole view scrollable, possibly bug...
            fullScreenBG
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

                Image.default("diamond")
                    .frame(width: 250, height: 250)

                VStack {
                    Image.default("cardPage")
                        .frame(width: 60, height: 60)

                    ShinyText(text: "捕光牌阵", font: .DefaultChineseFont, size: 14, textColor: Color("MediumLime"), shadowColor: Color.white.opacity(0.75))
                }
            }
        }
    }
}

struct IntroPageView: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var currentIndex = 0
    @State var percentatges: [CGFloat] = [0, 1, 2]
    let introductionPageCount = 3
    var body: some View {
        ZStack {
            PagerView(accentColor: .white, overlookColor: .gray, backgroundColor: Color.black.opacity(0.2), currentIndex: $currentIndex, percentages: $percentatges, customEnd: {
                withAnimation(springAnimation) {
                    profile.shouldShowEnergy = currentIndex == 2
                }
                print("Changing should show energy to \(profile.shouldShowEnergy)")
            }) {
                ForEach(0..<introductionPageCount) { index in
                    InnerIntroduction(percentage: percentatges[index]) {
                        if index == 0 {
                            FirstIntroPage()
                        } else if index == 1 {
                            SecondIntroPage()
                        } else if index == 2 {
                            ThirdIntroPage(onMe: currentIndex == index)
                                .onAppear { print("Is it really on me? currentIndex: \(currentIndex) and onMe: \(currentIndex == index) and index:  \(index)") }
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
    let baseScale: CGFloat = 0.75
    let baseOpacity: CGFloat = 0.25
    let baseTint: CGFloat = 0.75
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
//            .mask(
//                RoundedRectangle(cornerRadius: .ScreenCornerRadius).frame(width: .ScreenWidth, height: .ScreenHeight)
//                .scaleEffect(y: 2)
//            )

    }
}

struct IntroductionPageView_Previews: PreviewProvider {
    static var previews: some View {
        IntroPageView().edgesIgnoringSafeArea(.all).previewDevice("iPhone 11")
    }
}
