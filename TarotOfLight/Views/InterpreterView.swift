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
                    .transition(fromBottomToTop)
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
    let baseOffset: CGFloat = 100
    let imageOffset: CGFloat = 40
    let baseScale: CGFloat = 0.9
    let baseOpacity: CGFloat = 0.25
    let baseTint: CGFloat = 0.6
    @State var isEnergyAnimating = true
    var body: some View {
        let computedScale = (1.0 - abs(percentage)) * (1 - baseScale) + baseScale
        let computedOpacity = Double((1.0 - abs(percentage)) * (1 - baseOpacity) + baseOpacity)
        let computedTint = Double((1.0 - abs(percentage)) * (1 - baseTint) + baseTint)
        let computedTintColor = Color(red: computedTint, green: computedTint, blue: computedTint)
        return ZStack {
            ScrollView(showsIndicators: false) {
                CheckedLazyVStack {
                    VStack {
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(card.flipped ? .degrees(180) : .zero)
                            .frame(width: 270)
                            .padding(.top, 10)
                            .zIndex(1)
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
                            .zIndex(-0.5)
                    }
                        .offset(x: -percentage * imageOffset, y: -abs(percentage) * 60)
                        .scaleEffect(computedScale)

                    VStack {
                        WrapComb(title: "释义解读", text: card.interpretText)
                            .padding(.bottom, 30)
                        WrapComb(title: "牌面故事", text: card.storyText)
                            .padding(.bottom, 30)

                        // TODO: add the energy

                        HStack {
                            Image("star")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            ShinyText(text: "卜光能量", font: .DefaultChineseFont, size: 20, textColor: Color(hex: 0xF7EB2E), shadowColor: Color.black.opacity(0))
                        }
                            .offset(x: -15)
                        
                        LitPentagram(numberOfPentagram: card.fullEnergy, numberOfLit: card.energy)
                            .frame(height: 10)
                        
                        WebImage(
                            url: URL(fileURLWithPath: Bundle.main.path(forResource: "grown", ofType: "gif") ?? "grown.gif"), isAnimating: $isEnergyAnimating)
                            .resizable()
                            .playbackRate(1.0)
                            .retryOnAppear(true)
                            .scaledToFill()
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
            .zIndex(-Double(abs(percentage)))
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
    @EnvironmentObject var profile: UserProfile

    @State var percentages: [CGFloat] = [0.0, 1.0, 2.0]
    @State var currentIndex = 0
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                ShinyText(text: InterpretationStatus.mapper(from: currentIndex).chinese, size: 20, textColor: Color("MediumLime"), shadowColor: Color("MediumLime"))
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Button {
                        withAnimation(springAnimation) {
                            profile.weAreIn = .category
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
                        print("Currently we're using this to delete the user profile")
                        UserProfile.deleteFile()
                    } label: {
                        Image("share")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .shadow(color: Color("Lime"), radius: 3)
                    }
                    Button {
                        print("STUB: Should implement downloading the interpretation result here")
                        print("Currently we're using this to save things to user document profile so that no refreshing is needed")
                        profile.saveToFile()
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
                    WrapScroll(card: profile.cards[index], percentage: percentages[index])
                }
            }.background(TravelingBackground(nStroke: 20, nFill: 20))
        } // VStack
    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    @Binding var percentages: [CGFloat] // left, right middle
    let content: Content
    @State var translation: CGFloat = 0
    @EnvironmentObject var profile: UserProfile
    init(pageCount: Int, currentIndex: Binding<Int>, percentages: Binding<[CGFloat]>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self._percentages = percentages
        self.content = content()
    }
    struct PagerDot: View {
        @Binding var currentIndex: Int
        @Binding var translation: CGFloat
        @Binding var percentages: [CGFloat]
        var pageCount: Int
        var width: CGFloat
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<pageCount) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.white : Color.gray)
                            .frame(width: 10, height: 10)
                        // BUG: Cannot implement tap, I give up.
                    }
                }
            }
        }
    }
    
    @State var isChanging = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let width = geometry.size.width
                let PagerDragGesture =
                    DragGesture(
                        minimumDistance: 30,
                        coordinateSpace: .global
                    )
                    .onEnded { value in
                        let offset = value.predictedEndTranslation.width / width
                        let newIndex = (CGFloat(currentIndex) - offset).rounded()
                        let oldValue = currentIndex
                        currentIndex = min(max(Int(newIndex), 0), pageCount - 1)
                        isChanging = false
                        for _ in 0..<abs(currentIndex - oldValue) {
                            profile.complexSuccess()
                        }
                        print("Current translation: \(translation), currentIndex: \(currentIndex)")
                        withAnimation(fastSpringAnimation) {
                            translation = -CGFloat(currentIndex) * width
                            // DUP: duplicated code fragment, consider optimization
                            for index in 0..<pageCount {
                                percentages[index] = (translation + CGFloat(index) * width) / width
                            }
                        }
                        print("Paging gesture ended! Percentages are: [\(percentages[0]), \(percentages[1]), \(percentages[2])]")
                    }
                    .onChanged { value in
                        print("Paging gesture changing...")
                        let translationW = value.translation.width - CGFloat(currentIndex) * width
                        let translationH = value.translation.height
                        if isChanging || translationH < 10 {
                            print("Are we currently changing: \(isChanging)")
                            isChanging = true
                            withAnimation(fastSpringAnimation) {
                                translation = translationW
                                for index in 0..<pageCount {
                                    percentages[index] = (translationW + CGFloat(index) * width) / width
                                }
                            }
                        } else {
                            isChanging = false
                        }
                }

                HStack(spacing: 3) {
                    // BUG: Setting the spacing to 0 might cause strange behavior on the opacity during animation
                    // Possibly a bug of SwiftUI
                    // Here we have 3 Paging view, so 3*2 = 2*3
                    self.content.frame(width: geometry.size.width - 2)
                }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: translation)
                    .gesture(PagerDragGesture)
                    .zIndex(-1)
                PagerDot(currentIndex: $currentIndex, translation: $translation, percentages: $percentages, pageCount: pageCount, width: geometry.size.width)
                    .padding(.bottom, 50)
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
