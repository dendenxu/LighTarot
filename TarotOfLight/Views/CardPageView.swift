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
    var text = "时间之流"
    var description = "过去、现在和未来状况的占卜"
    var energy: Double = 50
    var locked = false

    static let `default` = CardContent(text: "时间之流", description: "过去、现在和未来状况的占卜", energy: 50, locked: false)
}
struct Card: View {
    @State var cardContent: CardContent
    @EnvironmentObject var profile: LighTarotModel
    var imageName: String {
        get {
            if profile.lockingSelection == .locked { return "cardBackH" }
            else { return (cardContent.locked) ? "Gray" : "having" }
        }
    }
    var textColor: Color { get { return (profile.lockingSelection == .locked) ? Color("LightPink") : Color("LightGray"); } }
    var shadowColor: Color { get { return (profile.lockingSelection == .locked) ? Color("LightPurple") : Color("LightGray"); } }
    var textColorDesc: Color { get { return (profile.lockingSelection == .locked) ? Color("Lime") : Color("LightGray"); } }
    var shadowColorDesc: Color { get { return (profile.lockingSelection == .locked) ? Color("Lime") : Color("LightGray"); } }
    var imageShadowColor: Color { get { return (!cardContent.locked || profile.lockingSelection == .locked) ? Color(.black).opacity(0.75) : Color(.black).opacity(0.3) } }
    var body: some View {
        Button(action: {
            print("DEBUG: Currently navigating to animation when a locked card is pressed\nand the ARCamera when card is unlocked")
            print("Give me some action upon hitting the button")
            profile.complexSuccess()
            withAnimation(springAnimation) {
                if !cardContent.locked || profile.lockingSelection == .locked { profile.weAreInGlobal = .arCamera }
                else { profile.weAreIn = .animation }
            }
        }) {
            ZStack(alignment: .topLeading) {
                Image.default(imageName)
                    .shadow(color: imageShadowColor, radius: 5)
                if !cardContent.locked || profile.lockingSelection == .locked {
                    VStack(alignment: .leading) {
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
    var lockedTexts: [CardContent] {
        var lockedContents = [CardContent]()
        for item in profile.cardContents { if (item.locked) { lockedContents.append(item) } }
        return lockedContents
    }

    // todo: add code to communicate with the backend
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .foregroundColor(Color("LightMediumDarkPurple"))
                    VStack(alignment: .leading) {
                        Button(action: {
                            print("Getting back...")
                            profile.complexSuccess()
                            withAnimation(fasterSpringAnimation) {
                                profile.weAreInGlobal = .selector;
                            }
                        }) {
                            ZStack(alignment: .topLeading) {
                                ShinyText(text: "< " + profile.weAreInCategory.descriptionChinese, font: .DefaultChineseFont, size: 20, textColor: Color("LightGray"))
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
                                    withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                                        profile.lockingSelection = .unlocked
                                    } }
                                ) {
                                    ShinyText(text: LockingSelection.unlocked.description, font: .DefaultChineseFont, size: 16, textColor: profile.lockingSelection == .unlocked ? profile.lockingSelection.foregroundColor : Color("LightGray"), shadowColor: profile.lockingSelection == .unlocked ? profile.lockingSelection.foregroundColor : Color("LightGray"))
                                }
                                Button (action: {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                                        profile.lockingSelection = .locked
                                    } }
                                ) {
                                    ShinyText(text: LockingSelection.locked.description, font: .DefaultChineseFont, size: 16, textColor: profile.lockingSelection == .locked ? profile.lockingSelection.foregroundColor : Color("LightGray"), shadowColor: profile.lockingSelection == .locked ? profile.lockingSelection.foregroundColor : Color("LightGray"))
                                }
                            }
                        }

                        VStack(alignment: .center) {
                            HStack(spacing: 30) {
                                Spacer()
                                (profile.lockingSelection == .unlocked ? profile.lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                (profile.lockingSelection == .locked ? profile.lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                Spacer()
                            }.background(profile.lockingSelection.backgroundColor)
                                .frame(height: 3)

                        }
                    }


                }


            }
                .frame(width: .ScreenWidth, height: 120)
                .shadow(radius: 20)
                .zIndex(1)

            if profile.lockingSelection == .locked {
                FullScroll(texts: lockedTexts)
                    .frame(width: .ScreenWidth)
                    .zIndex(0.5)
            } else {
                FullScroll(texts: profile.cardContents)
                    .frame(width: .ScreenWidth)
                    .zIndex(0.5)
            }

        }

    }
}

struct FullScroll: View {
    @State var texts: [CardContent]
    var body: some View {
        ScrollView(showsIndicators: false) {
            CheckedLazyVStack {
                ForEach(texts.indices) { idx in
                    Card(cardContent: self.texts[idx])
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
