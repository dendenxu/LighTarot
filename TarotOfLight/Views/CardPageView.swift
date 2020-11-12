//
//  CategoryView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct LightText: View {
    var text = "解锁新牌阵"
    var font = String.SourceHanSansHeavy
    var size: CGFloat = 12.0
    var textColor = Color("LightPink")
    var shadowColor = Color.white
    var body: some View {
        Text(self.text)
            .font(.custom(self.font, size: self.size))
            .foregroundColor(textColor)
            .shadow(color: self.shadowColor.opacity(0.8), radius: 10)
    }

}
struct CardContent {
    // default values are already here
    var text = "时间之流"
    var description = "过去、现在和未来状况的占卜"
    var energy: Double = 50
    var locked = false
    var lockedImageName = "cardBackH"
    var unlockedImageName = "having"

    static let `default` = CardContent()
}
struct Card: View {
    let cardContent: CardContent
    let locked: Bool
    @EnvironmentObject var profile: LighTarotModel
    var imageName: String {
        get {
            if locked { return cardContent.lockedImageName }
            else { return (cardContent.locked) ? "Gray" : cardContent.unlockedImageName }
        }
    }
    var textColor: Color { get { return (locked) ? Color("LightPink") : Color("LightGray"); } }
    var shadowColor: Color { get { return (locked) ? Color("LightPurple") : Color("LightGray"); } }
    var textColorDesc: Color { get { return (locked) ? Color("Lime") : Color("LightGray"); } }
    var shadowColorDesc: Color { get { return (locked) ? Color("Lime") : Color("LightGray"); } }
    var imageShadowColor: Color { get { return (!cardContent.locked || locked) ? Color(.black).opacity(0.75) : Color(.black).opacity(0.3) } }
    var body: some View {
        Button(action: {
            print("DEBUG: Currently navigating to animation when a locked card is pressed\nand the ARCamera when card is unlocked")
            print("Give me some action upon hitting the button")
            profile.complexSuccess()
            withAnimation(springAnimation) {
                if !cardContent.locked || locked { profile.navigator.weAreInGlobal = .arCamera }
                else { profile.navigator.weAreIn = .animation }
            }
        }) {
            ZStack(alignment: .topLeading) {
                Image.default(imageName)
                    .shadow(color: imageShadowColor, radius: 5)
                if !cardContent.locked || locked {
                    VStack(alignment: .leading, spacing: 5) {
                        LightText(text: cardContent.text, font: .DefaultChineseFont, size: 20, textColor: textColor, shadowColor: shadowColor)
                            .padding(.top, 20).padding(.leading, 20)
                        HStack {
                            Image.default("power")
                                .frame(width: 20, height: 20)
                            LightText(text: String(format: "%.0f能量", cardContent.energy), font: .DefaultChineseFont, size: 16, textColor: textColorDesc, shadowColor: shadowColorDesc)
                        }.padding(.leading, 20)
                    }
                } else {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Spacer()
                        Text("参与牌阵占卜捕获更多能量\n来解锁新牌阵吧！")
                            .font(.custom(.SourceHanSansMedium, size: 16))
                            .foregroundColor(Color(hex: 0x888888))
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CardPageView: View {
    @EnvironmentObject var profile: LighTarotModel
    var currentIndex: Int { profile.navigator.lockingSelection == .unlocked ? 0 : 1 }
    @State var percentatges: [CGFloat] = [0, 1]
    let cardPageCount = 2
    let uuid = UUID()
    // todo: add code to communicate with the backend
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                // MARK: BUG ON IPHONE 12
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Button(action: {
                            print("Getting back...")
                            profile.complexSuccess()
                            withAnimation(fasterSpringAnimation) {
                                profile.navigator.weAreInGlobal = .selector;
                            }
                        }) {
                            ZStack(alignment: .topLeading) {
                                ShinyText(text: "< " + profile.navigator.weAreInCategory.descriptionChinese, font: .DefaultChineseFont, size: 20, textColor: Color("LightGray"))
                            }
                        }
                            .padding(.top, 50)
                            .padding(.leading, 20)

                        Spacer()

                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                            }
                            HStack(spacing: 30) {
                                Button (action: {
                                    withAnimation(slowSpringAnimation) {
                                        profile.navigator.lockingSelection = .unlocked
                                    }
                                    NotificationCenter.default.post(
                                        name: NSNotification.PagerTapped, object: nil, userInfo: ["uuid": uuid, "currentIndex": currentIndex])
                                }
                                ) {
                                    ShinyText(text: LockingSelection.unlocked.description, font: .DefaultChineseFont, size: 16, textColor: profile.navigator.lockingSelection == .unlocked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray"), shadowColor: profile.navigator.lockingSelection == .unlocked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray"))
                                }
                                Button (action: {
                                    withAnimation(slowSpringAnimation) {
                                        profile.navigator.lockingSelection = .locked
                                    }
                                    NotificationCenter.default.post(
                                        name: NSNotification.PagerTapped, object: nil, userInfo: ["uuid": uuid, "currentIndex": currentIndex])
                                }
                                ) {
                                    ShinyText(text: LockingSelection.locked.description, font: .DefaultChineseFont, size: 16, textColor: profile.navigator.lockingSelection == .locked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray"), shadowColor: profile.navigator.lockingSelection == .locked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray"))
                                }
                            }
                                .padding(.bottom, 10)
                        }.background(
                            GeometryReader {
                                geo in
                                VStack(alignment: .center) {
                                    HStack(spacing: 30) {
                                        Spacer()
                                        (profile.navigator.lockingSelection == .unlocked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                        (profile.navigator.lockingSelection == .locked ? profile.navigator.lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                        Spacer()
                                    }.background(profile.navigator.lockingSelection.backgroundColor)
                                        .frame(height: 3)
                                }.frame(width: geo.size.width, height: geo.size.height)
                                    .offset(y: geo.size.height / 2)
                            }
                        )


                    }
                }
            }
                .frame(width: .ScreenWidth, height: 130) // On iPhone 12 setting this to 120 seems to be causing bugs
            .shadow(radius: 20)
                .zIndex(1)

            ZStack {
                PagerView(accentColor: .white, overlookColor: .gray, backgroundColor: Color.black.opacity(0.2), hasPageDot: false, pageCount: cardPageCount, uuid: uuid, currentIndex: Binding<Int>.init(get: { currentIndex }, set:
                    { switch $0 {
                        case 0:
                            profile.navigator.lockingSelection = .unlocked
                        case 1:
                            profile.navigator.lockingSelection = .locked
                        default:
                            profile.navigator.lockingSelection = .unlocked
                    } }), percentages: $percentatges, customEnd: {
                    withAnimation(springAnimation) {
                        profile.navigator.lockingSelection = (currentIndex == 1) ? .locked : .unlocked
                    }
                    print("Changing locking state to \(profile.navigator.lockingSelection)")
                }) {
                    FullScroll(texts: profile.cardContents, locked: false)
                        .frame(width: .ScreenWidth)
                        .zIndex(0.5)

                    FullScroll(texts: profile.lockedTexts, locked: true)
                        .frame(width: .ScreenWidth)
                        .zIndex(0.5)
                }
                    .background(Rectangle()
                        .foregroundColor(Color("LightGray"))
                        .frame(width: .ScreenWidth * 2)
                    )
            }
        }
    }
}

struct FullScroll: View {
    @State var texts: [CardContent]
    let locked: Bool
    var body: some View {
        ScrollView(showsIndicators: false) {
            CheckedLazyVStack {
                ForEach(texts.indices) { idx in
                    Card(cardContent: self.texts[idx], locked: locked)
                        .padding(30)
                }
            }
            // todo: finish the cards scroll view, currently cards are loaded statically
        }.background(Color("LightGray"))
    }
}

// Page changer
enum CategorySelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .love: return "love"
        case .relation: return "relation"
        case .career: return "career"
        case .wealth: return "wealth"
        }
    }

    var descriptionChinese: String {
        switch self {
        case .love: return "遇见感情"
        case .relation: return "人际交往"
        case .career: return "事业先知"
        case .wealth: return "财富世运"
        }
    }

    case love
    case relation
    case career
    case wealth
}


enum LockingSelection {
    var description: String {
        switch self {
        case .locked: return "未解锁"
        case .unlocked: return "已拥有"
        }
    }
    var foregroundColor: Color {
        switch self {
        case .locked: return Color("LightPink")
        case .unlocked: return Color("MediumLime")
        }
    }
    var backgroundColor: Color {
        switch self {
        case .locked: return Color("DarkPurple")
        case .unlocked: return Color("MediumLime")
        }
    }
    case locked
    case unlocked
}
