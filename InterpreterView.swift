//
//  InterpreterView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/9.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct OuterInterpreterView: View {
    @State var plantFullAnimating: Bool = true
    @State var placerHolderDelay: Bool = false // STUB: should communicate with backend instead
    var body: some View {
        ZStack {
            if !placerHolderDelay {
                Button(action: {
                    if !placerHolderDelay {
                        withAnimation(springAnimation) {
                            placerHolderDelay = true
                        }
                        print("Animation done, should show interpretation")
                    } else {
                        print("Not the first time called")
                    }
                }) {
                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plantfull", ofType: "gif") ?? "plantfull.gif"),
                        isAnimating: self.$plantFullAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                        .onAppear(perform: delay)
                }
            } else {
                InterpreterView()
            }


        }
    }
    private func delay() {
        // Delay of 3 seconds
        print("Playing the animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if !placerHolderDelay {
                withAnimation(springAnimation) {
                    placerHolderDelay = true
                }
                print("Animation done, should show interpretation")
            } else {
                print("Not the first time called")
            }

        }
    }
}


struct CheckedLazyVStack<Content: View>: View {
    var alignment: HorizontalAlignment
    var spacing: CGFloat
    var content: Content
    init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 10, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        } else {
            // Fallback on earlier versions
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

struct InterpreterView: View {
    var cards = [CardInfo(imageName: "theHierophant", interpretText: "    援助、同情、宽宏大量，可信任的人给予的劝告，良好的商量对象，得到精神上的满足，遵守规则。\n\n    爱情上屈从于他人的压力，只会按照对方的要求来盲目改变自己，自以为这是必要的付出，其实不过是被迫的选择。伴侣也不会对你保持忠诚，并很难满足双方真实的需要。", storyText: "    这是一张代表唤醒良心与善良觉醒的牌，同时也是张关于宗教信仰与传统的牌。\n    同皇帝所代表的物质主宰相比，他更趋向于精神层面，他是精神方面的权威，是未知世界的解释者。因为教皇能够直接与上帝联系，他用慈悲与洞察力试图拯救世人的灵魂，并用自己的言论引导人们走向正途。\n    牌面中的教皇高举双手向世人传播教义，信徒们虔诚地跪在地上聆听他的教诲。然而需要注意的是他同时也是传统知识和保守道德的代表，他控制人们的思维，使人的眼界变得狭小。只有彻底放弃陈旧的一切，探索新的解决方式，可能还有希望。")]
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                ShinyText(text: "✨过去的状态✨", size: 20, textColor: Color("MediumLime"), shadowColor: Color("MediumLime"))
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Image("share")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .shadow(color: Color("Lime"), radius: 3)
                    Image("download")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .shadow(color: Color("Lime"), radius: 3)
                }
            }
                .padding(.top, 60)
                .padding(.horizontal, 30)


            ScrollView {
                CheckedLazyVStack {
                    Image(cards[0].imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.top, 10)
                        .zIndex(1)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .opacity(0.35)
                            .foregroundColor(Color(hex: 0xaaaaaa))
                            .frame(width: 180, height: 50)
                            .shadow(color: Color.black.opacity(0.95), radius: 2)
                        VStack(spacing: 5) {
                            ShinyText(text: "教皇", font: .DefaultChineseFont, size: 16, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                            ShinyText(text: "(正位)", font: "Source Han Sans Heavy", size: 13, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                        }.opacity(0.9)
                    }.background(ShinyBackground(
                        nStroke: 20,
                        nFill: 20,
                        size: CGSize(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        ))
                    )
                        .padding(.top, 15)
                        .padding(.bottom, 25)
                        .zIndex(-0.5)

                    CheckedLazyVStack(spacing: 60) {
                        WrapComb(title: "释义解读", text: cards[0].interpretText)
                        WrapComb(title: "牌面故事", text: cards[0].storyText)
                    }

                    Spacer()
                }
            }
        }
    }
}


struct WrapComb: View {
    var title = "释义解读"
    var text = "    援助、同情、宽宏大量，可信任的人给予的劝告，良好的商量对象，得到精神上的满足，遵守规则。\n\n    爱情上屈从于他人的压力，只会按照对方的要求来盲目改变自己，自以为这是必要的付出，其实不过是被迫的选择。伴侣也不会对你保持忠诚，并很难满足双方真实的需要。"
    var body: some View {
        VStack {
            HStack {
                Image("star")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                ShinyText(text: title, font: "Source Han Sans Heavy", size: 20, textColor: Color(hex: 0xF7EB2E), shadowColor: Color.black.opacity(0))
            }
                .offset(x: -15)
//                .shadow(color: Color.black.opacity(0.6), radius: 3)
            WrapText(text: text).padding(.top, 50)
        }
    }
}

struct WrapText: View {
    var text = "Placeholder Text"
    var body: some View {
        Text(text)
            .font(Font.custom("Source Han Sans Medium", size: 14.5))
            .lineSpacing(5)
            .foregroundColor(.white)
            .frame(width: 260)
            .background(RoundedRectangle(cornerRadius: 10)
                .opacity(0.25)
                .foregroundColor(.white)
//                .shadow(color: Color.black.opacity(0.95), radius: 5)
            // TODO: HEADACHE, how to implement this?
            .scaleEffect(x: 1.2, y: 1.3, anchor: .center)
            )
    }
}

struct CardInfo {
    var imageName: String
    var interpretText: String
    var storyText: String
}
