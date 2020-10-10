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
    @Binding var weAreIn: PredictLightViewSelection
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
                InterpreterView(weAreIn: $weAreIn)
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

struct WrapScroll: View {
    var card: CardInfo
    var percentage: CGFloat
    var body: some View {
        ScrollView {
            CheckedLazyVStack {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270)
                    .padding(.top, 10)
                    .zIndex(1)
                ZStack {
                    VStack(spacing: 5) {
                        Spacer().frame(width: 1, height: 4)
                        ShinyText(text: "教皇", font: .DefaultChineseFont, size: 20, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                        ShinyText(text: "(正位)", font: "Source Han Sans Heavy", size: 16, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                        Spacer().frame(width: 1, height: 4)
                    }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .opacity(0.35)
                            .foregroundColor(Color(hex: 0xaaaaaa))
                            .shadow(color: Color.black.opacity(0.95), radius: 2)
                            .frame(width: 180)
//                                .scaledToFill()
                        )
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


                WrapComb(title: "释义解读", text: card.interpretText)
                    .padding(.bottom, 30)
                WrapComb(title: "牌面故事", text: card.storyText)
                    .padding(.bottom, 30)

                // TODO: add the energy
                Spacer()
            }
        }
    }
}

struct InterpreterView: View {
    @Binding var weAreIn: PredictLightViewSelection
    var cards = [
        CardInfo(
            imageName: "theHierophant",
            interpretText: "    援助、同情、宽宏大量，可信任的人给予的劝告，良好的商量对象，得到精神上的满足，遵守规则。\n\n    爱情上屈从于他人的压力，只会按照对方的要求来盲目改变自己，自以为这是必要的付出，其实不过是被迫的选择。伴侣也不会对你保持忠诚，并很难满足双方真实的需要。",
            storyText: "    这是一张代表唤醒良心与善良觉醒的牌，同时也是张关于宗教信仰与传统的牌。\n\n    同皇帝所代表的物质主宰相比，他更趋向于精神层面，他是精神方面的权威，是未知世界的解释者。因为教皇能够直接与上帝联系，他用慈悲与洞察力试图拯救世人的灵魂，并用自己的言论引导人们走向正途。\n\n    牌面中的教皇高举双手向世人传播教义，信徒们虔诚地跪在地上聆听他的教诲。然而需要注意的是他同时也是传统知识和保守道德的代表，他控制人们的思维，使人的眼界变得狭小。只有彻底放弃陈旧的一切，探索新的解决方式，可能还有希望。"
        ),
        CardInfo(
            imageName: "queenOfSword",
            interpretText: "    思考清晰，有耐性且理性的人，情绪波动起伏不大，自我管理得很好，而在思考方面则相当的敏捷且迅速。\n\n    暗示着自己在这一段感情之中是站在主导的位置，因为自己懂得运用那敏捷的思考能力来分析这一段感情可能发生的一些变化，并且找出一些问题来克服，也小心谨慎的观察着对方心情上的变化，并且找出应对的方法。",
            storyText: "    这位面貌冷峻的女子，侧身向着我们，脸朝画面的右方，以右手直举着剑。她的左手伸出手臂高举，做着排拒的手势。\n\n    女子的座椅就位于旷野之中，可以看到她身后的远方有几颗树木。 云霭低垂笼罩地面，其上萧飒的天空中，可见到遥远处有一只孤独的飞鸟。\n\n    是想法的管理者与将理念推动的人物，是一位军师级的人物，其本身具有相当的专业性，与其讨论事情可以给与其专业上的协助，讲出的是专业的智慧指导，提出自己的见解，告诉他人背后的理念与原理是什么，并且能够从多个角度上去分析，采取客观的态度，极高度的分析能力，提出最佳的建议，与精辟的见解"
        ),
        CardInfo(
            imageName: "pageOfCups",
            interpretText: "    有坚强的信念，现在的失意会影响你的心情，使你显得郁郁寡欢的。虽然如此，平日也还能亲切待人，是非常难得的！\n\n    你对目前的关系感到失望，不能从中得到满足，这会使你们的感情更危险，不妨仔细想一想其中的原因，相信一定会有所领悟的！",
            storyText: "    圣杯侍从，温和而纯粹。\n\n    杯之中的鱼儿—象征着想象之力—自杯中探出了脑袋，侍从的注意力也为之吸引，但是他并没有多余的动作，只是觉得有趣而认真的回望。并未采取任何多余的行动，他放任自己想象并且不以世俗是桎梏来约束。\n\n    而对于水所代表的情感，他也充满了好奇与期盼，追求着纯粹的享受。因为他的心灵纯净，所以才能最大限度的发挥自己的想象与精神。\n\n    自这份纯粹的想象之中，他将开启自己正常的道路，对于心灵世界的探索以及心灵能力的开发，以着一种平和而稳定的方式。"
        )
    ]

    @State var percentages: [CGFloat] = [1.0, 0.0, 0.0]
    @State var currentIndex = 0
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                ShinyText(text: "✨过去的状态✨", size: 20, textColor: Color("MediumLime"), shadowColor: Color("MediumLime"))
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        withAnimation(springAnimation) {
                            weAreIn = .category
                        }
                    } label: {
                        Image("getback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }


                    Spacer()
                    Button {
                        print("STUB: Should implement sharing the interpretation result here")
                    } label: {
                        Image("share")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }
                    Button {
                        print("STUB: Should implement downloading the interpretation result here")
                    } label: {
                        Image("download")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }
                }
            }
                .padding(.top, 60)
                .padding(.horizontal, 30)

            PagerView(pageCount: 3, currentIndex: $currentIndex, percentages: $percentages) {
                ForEach(0..<3) { index in
                    WrapScroll(card: cards[index], percentage: percentages[index])
                }
            }


        }
    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    @Binding var percentages: [CGFloat] // left, right middle
    let content: Content
    @State var translation: CGFloat = 0
    init(pageCount: Int, currentIndex: Binding<Int>, percentages: Binding<[CGFloat]>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self._percentages = percentages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 3) {
                    // BUG: Setting the spacing to 0 might cause strange behavior on the opacity during animation
                    // Possibly a bug of SwiftUI
                    // Here we have 3 Paging view, so 3*2 = 2*3
                    self.content.frame(width: geometry.size.width - 2)
                }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: translation)
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                let offset = value.predictedEndTranslation.width / geometry.size.width
                                let newIndex = (CGFloat(currentIndex) - offset).rounded()
                                currentIndex = min(max(Int(newIndex), 0), pageCount - 1)
                                print("Current translation: \(translation), currentIndex: \(currentIndex)")
                                withAnimation(fastSpringAnimation) {
                                    translation = -CGFloat(currentIndex) * geometry.size.width
                                    // DUP: duplicated code fragment, consider optimization
                                    for index in 0..<pageCount {
                                        percentages[index] = (translation + CGFloat(index) * geometry.size.width) / geometry.size.width
                                    }
                                }
                                print("Paging gesture ended!")
                            }
                            .onChanged { value in
                                print("Paging gesture changing...")
                                translation = value.translation.width - CGFloat(currentIndex) * geometry.size.width
                                for index in 0..<pageCount {
                                    percentages[index] = (translation + CGFloat(index) * geometry.size.width) / geometry.size.width
                                }
                        }
                    )

                VStack {
                    Spacer()
                    HStack {
                        ForEach(0..<pageCount, id: \.self) { index in
                            Button {
                                withAnimation(fastSpringAnimation) {
                                    currentIndex = index
                                }
                                print("Button of index \(index) is hit!")
                                // TODO: Check why this isn't hit
                            } label: {
                                Circle()
                                    .fill(index == currentIndex ? Color.white : Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    Spacer().frame(height: 30)
                }
            }
        }
    }
}

struct WrapComb: View {
    var title = "TITLE"
    var text = "Some long long long text"
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Image("star")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                ShinyText(text: title, font: .DefaultChineseFont, size: 20, textColor: Color(hex: 0xF7EB2E), shadowColor: Color.black.opacity(0))
            }
                .offset(x: -15)
                .padding(.bottom, 10)
//                .shadow(color: Color.black.opacity(0.6), radius: 3)
            WrapText(text: text)
        }
    }
}

struct WrapText: View {
    var text = "Placeholder Text"
    var body: some View {
        VStack {
            Spacer().frame(width: 1, height: 30)
            Text(text)
                .font(Font.custom("Source Han Sans Heavy", size: 14.5))
                .lineSpacing(2)
                .foregroundColor(.white)
                .frame(width: 260)
            Spacer().frame(width: 1, height: 30)
        }
            .background(RoundedRectangle(cornerRadius: 10)
                .opacity(0.25)
                .foregroundColor(.white)
                .scaleEffect(x: 1.2, y: 1, anchor: .center)
            )
    }
}

struct CardInfo {
    var imageName: String
    var interpretText: String
    var storyText: String
}
