//
//  InterpreterView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/9.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreHaptics
struct OuterInterpreterView: View {
    @State var plantFullAnimating: Bool = true
    @State var placerHolderDelay: Bool = false // STUB: should communicate with backend instead
    var body: some View {
        ZStack {
            if !placerHolderDelay {
                Button(action: {
                    if !placerHolderDelay {
                        withAnimation(fasterSpringAnimation) {
                            placerHolderDelay = true
                        }
                        print("Animation done, should show interpretation")
                    } else {
                        print("Not the first time called")
                    }
                }) {
                    WebImage.default(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plantfull", ofType: "gif") ?? "plantfull.gif"),
                        isAnimating: self.$plantFullAnimating)
                        .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                        .onAppear(perform: delay)
                }
            } else {
                // MARK: We've made sure that arbitrary number of pages are available in this Small Pager View
                InterpreterView(currentIndex: 0, pageCount: 3)
                    .transition(fromBottomToTop)
            }


        }
    }
    private func delay() {
        // Delay of 5 seconds
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
    let baseOffset: CGFloat = 100 / 414 * .ScreenWidth
    let imageOffset: CGFloat = 40 / 414 * .ScreenWidth
    let baseScale: CGFloat = 0.9
    let baseOpacity: CGFloat = 0.25
    let baseTint: CGFloat = 0.6
    let baseBlur: CGFloat = 3
    @State var isEnergyAnimating = true
    var body: some View {
        let computedScale = (1.0 - abs(percentage)) * (1 - baseScale) + baseScale
        let computedOpacity = Double((1.0 - abs(percentage)) * (1 - baseOpacity) + baseOpacity)
        let computedTint = Double((1.0 - abs(percentage)) * (1 - baseTint) + baseTint)
        let computedTintColor = Color(red: computedTint, green: computedTint, blue: computedTint)
        let computedBlur = (abs(percentage)) * baseBlur
        return ZStack {
            ScrollView(showsIndicators: false) {
                CheckedLazyVStack {
                    VStack {
                        Image.default(card.imageName)
                            .rotationEffect(card.flipped ? .degrees(180) : .zero)
                            .frame(width: 270)
                            .padding(.top, 10)
                            .colorMultiply(computedTintColor)
                        ZStack {
                            VStack(spacing: 5) {
                                Spacer().frame(width: 1, height: 4)
                                ShinyText(text: card.name, font: .DefaultChineseFont, size: 20, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                                ShinyText(text: card.flipped ? "(逆位)" : "(正位)", font: .SourceHanSansHeavy, size: 16, textColor: Color("StrangePurple"), shadowColor: Color.black.opacity(0))
                                Spacer().frame(width: 1, height: 4)
                            }
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .opacity(0.35)
                                    .foregroundColor(Color(hex: 0xaaaaaa))
                                    .shadow(color: Color.black.opacity(0.95), radius: 2)
                                    .frame(width: 180)
                                )
                        }
                            .padding(.top, 15)
                            .padding(.bottom, 25)
                    }
                        .offset(x: -percentage * imageOffset, y: -abs(percentage) * 60)
                        .scaleEffect(computedScale)

                    VStack {
                        WrapComb(title: "释义解读", text: card.interpretText)
                            .padding(.bottom, 30)
                        WrapComb(title: "牌面故事", text: card.storyText)
                            .padding(.bottom, 30)
                        HStack {
                            Image.default("star")
                                .frame(width: 30)
                            ShinyText(text: "卜光能量", font: .DefaultChineseFont, size: 20, textColor: Color(hex: 0xF7EB2E), shadowColor: Color.black.opacity(0))
                        }
                            .offset(x: -15)

                        LitPentagram(numberOfPentagram: card.fullEnergy, numberOfLit: card.energy)
                            .frame(height: 10)

                        WebImage.default(
                            url: URL(fileURLWithPath: Bundle.main.path(forResource: "grown", ofType: "gif") ?? "grown.gif"), isAnimating: $isEnergyAnimating)
                            .frame(width: 100, height: 100)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10)
                        Spacer()
                    } // WrapCombs
                    .opacity(computedOpacity)

                } // CheckedLazyVStack
                .scaleEffect(y: computedScale)
            } // ScrollView
        } // ZStack
        .offset(x: -percentage * baseOffset)
            .scaleEffect(x: computedScale)
            .zIndex(-2 + Double(abs(percentage)))
            .blur(radius: computedBlur)
    }
}

struct LitPentagram: View {
    let numberOfPentagram: Int
    let numberOfLit: Int
    let foregroundColor = Color("Gold")
    let backgroundColor = Color.black.opacity(0.2)
    init(numberOfPentagram: Int, numberOfLit: Int) {
        self.numberOfPentagram = numberOfPentagram
        self.numberOfLit = (numberOfPentagram >= numberOfLit) ? numberOfLit : numberOfPentagram
    }
    var body: some View {
        HStack {
            ForEach(0..<numberOfLit) { index in
                Image("starfull")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(foregroundColor)
            }
            ForEach(0..<(numberOfPentagram - numberOfLit)) { index in
                Image("starfull")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(backgroundColor)
            }
        }
    }
}

struct InterpreterView: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var percentages: [CGFloat] = [CGFloat]()
    @State var currentIndex: Int = 0
    var pageCount: Int
    init(currentIndex: Int = 0, pageCount: Int = 3) {
        self._currentIndex = State(initialValue: currentIndex)
        self.pageCount = pageCount
        print("Getting currentIndex: \(currentIndex) and pageCount: \(pageCount)")
        var thePercentages = [CGFloat]()
        for i in 0..<pageCount {
            print("CurrentValue: \(CGFloat(i))")
            thePercentages.append(CGFloat(i))
        }
        _percentages = State(initialValue: thePercentages)
        print("After initialization, pageCount: \(pageCount), percentages: \(percentages)")
    }
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                ShinyText(text: InterpretationStatus.mapper(from: currentIndex).chinese, size: 20, textColor: Color("MediumLime"), shadowColor: Color("MediumLime"))
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        withAnimation(fasterSpringAnimation) {
                            profile.navigator.weAreIn = .category
                        }
                    } label: {
                        Image.default("getback")
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }


                    Spacer()
                    Button {
                        print("STUB: Should implement sharing the interpretation result here")
                        print("Currently we're using this to delete the user profile")
                        LighTarotModel.deleteDocumentFile(filename: "profile.json")
                        LighTarotModel.deleteDocumentFile(filename: "CardContent.json")
                    } label: {
                        Image.default("share")
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }
                    Button {
                        print("STUB: Should implement downloading the interpretation result here")
                        print("Currently we're using this to save things to user document profile so that no refreshing is needed")
                        profile.saveUserInfoToFile()
                        profile.saveCardContentToFile()
                    } label: {
                        Image.default("download")
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }
                }
            }
                .padding(.top, 60)
                .padding(.horizontal, 30)

            ZStack {
                PagerView(pageCount: pageCount, currentIndex: $currentIndex, percentages: $percentages) {
                    ForEach(0..<pageCount) { index in
                        WrapScroll(card: profile.cardInfos[index], percentage: percentages[index])
                    }
                }.background(TravelingBackground(nStroke: 20, nFill: 20))
            }

        } // VStack
        .onAppear {
            print("ShouldShowEnergy of the model set to true!")
            profile.shouldShowEnergy = true
        }
    }
}

struct WrapComb: View {
    var title = "TITLE"
    var text = "Some long long long text"
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Image.default("star")
                    .frame(width: 30)
                ShinyText(text: title, font: .DefaultChineseFont, size: 20, textColor: Color(hex: 0xF7EB2E), shadowColor: Color.black.opacity(0))
            }
                .offset(x: -15)
                .padding(.bottom, 10)
            //.shadow(color: Color.black.opacity(0.6), radius: 3)
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
                .font(Font.custom(.SourceHanSansHeavy, size: 14.5))
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
    var name: String
    var flipped: Bool
    var imageName: String
    var interpretText: String
    var storyText: String
    var energy: Int
    var fullEnergy = 5
    static let `default` = CardInfo(
        name: "教皇",
        flipped: false,
        imageName: "theHierophantSVG",
        interpretText: "    援助、同情、宽宏大量，可信任的人给予的劝告，良好的商量对象，得到精神上的满足，遵守规则。\n\n    爱情上屈从于他人的压力，只会按照对方的要求来盲目改变自己，自以为这是必要的付出，其实不过是被迫的选择。伴侣也不会对你保持忠诚，并很难满足双方真实的需要。",
        storyText: "    这是一张代表唤醒良心与善良觉醒的牌，同时也是张关于宗教信仰与传统的牌。\n\n    同皇帝所代表的物质主宰相比，他更趋向于精神层面，他是精神方面的权威，是未知世界的解释者。因为教皇能够直接与上帝联系，他用慈悲与洞察力试图拯救世人的灵魂，并用自己的言论引导人们走向正途。\n\n    牌面中的教皇高举双手向世人传播教义，信徒们虔诚地跪在地上聆听他的教诲。然而需要注意的是他同时也是传统知识和保守道德的代表，他控制人们的思维，使人的眼界变得狭小。只有彻底放弃陈旧的一切，探索新的解决方式，可能还有希望。",
        energy: 4
    )
}

enum InterpretationStatus: Int {
    case past = 0
    case now
    case future
    var index: Int {
        return rawValue
    }
    var value: String {
        return String(describing: self)
    }
    var chinese: String {
        switch rawValue {
        case 0: return "✨过去的状态✨"
        case 1: return "✨现在的状态✨"
        case 2: return "✨未来的状态✨"
        default: return "我也不知道的状态"
        }
    }
    static func mapper(from: Int) -> InterpretationStatus {
        switch from {
        case 0: return .past
        case 1: return .now
        case 2: return .future
        default: return .past
        }
    }
}
