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
    var font = "Source Han Sans Heavy"
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
    var decription = "过去、现在和未来状况的占卜"
    var energy = 50
    var locked = false
}
struct Card: View {
    @State var cardContent: CardContent
    @Binding var lockingSelection: LockingSelection
    var imageName: String {
        get {
            if self.cardContent.locked {
                return "Gray"
            }
            else {
                return (self.lockingSelection == .locked) ? "cardBackH" : "having"
            }

        }
    }
    var textColor: Color {
        get {
            return (self.lockingSelection == .locked) ? Color("LightPink") : Color("LightGray");
        }
    }
    var shadowColor: Color {
        get {
            return (self.lockingSelection == .locked) ? Color("LightPurple") : Color("LightGray");
        }
    }
    var textColorDesc: Color {
        get {
            return (self.lockingSelection == .locked) ? Color("Lime") : Color("LightGray");
        }
    }
    var shadowColorDesc: Color {
        get {
            return (self.lockingSelection == .locked) ? Color("Lime") : Color("LightGray");
        }
    }

    var imageShadowColor: Color {
        get {
            return (self.cardContent.locked == false) ? Color(.black).opacity(0.75) : Color(.black).opacity(0.3)
        }
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .shadow(color: imageShadowColor, radius: 5)
            if !cardContent.locked {
                VStack(alignment: .leading) {
                    LightText(text: cardContent.text, font: "DFPHeiW12-GB", size: 20, textColor: textColor, shadowColor: shadowColor)
                        .padding(.top, 20).padding(.leading, 20)
                    HStack {
                        if lockingSelection == .locked {
                            Image("power")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        } else {
                            Rectangle()
                                .foregroundColor(Color.white.opacity(0))
                                .frame(width: 0, height: 20)
                        }
                        LightText(text: String(cardContent.energy) + "能量", font: "DFPHeiW12-GB", size: 16, textColor: textColorDesc, shadowColor: shadowColorDesc)
                    }.padding(.leading, 20)
                }
            }
        }
            .padding(30)
    }
}

struct CategoryView: View {
    @Binding var weAreInCategory: CategorySelection
    @Binding var weAreInGlobal: GlobalViewSelection
    @State var lockingSelection: LockingSelection = .locked
    @State var texts = [
        CardContent(text: "爱之🌟占卜法", energy: 50),
        CardContent(text: "吉普赛十字法", energy: 20),
        CardContent(text: "六芒🌟占卜法", energy: 30),
        CardContent(text: "灿烂的❤️", energy: 100),
        CardContent(text: "灿烂的❤️", energy: 100),
        CardContent(text: "灿烂的❤️", energy: 100),
        CardContent(text: "灿烂的❤️", energy: 100),
    ]
    @State var unlockedTexts = [
        CardContent(text: "时间之流", decription: "过去、现在和未来状况的占卜", locked: false),
        CardContent(text: "吉普赛十字法", energy: 20, locked: true),
        CardContent(text: "六芒🌟占卜法", energy: 30, locked: true),
        CardContent(text: "灿烂的❤️", energy: 100, locked: true),
    ]

//    var touseTexts: [CardContent] {
//        get {
//            return (self.lockingSelection == .locked) ? self.texts : self.unlockedTexts
//        }
//    }

    // todo: add code to communicate with the backend
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color("LightMediumDarkPurple"))
                    VStack(alignment: .leading) {
                        Button(action: {
                            withAnimation(springAnimation) {
                                self.weAreInGlobal = .selector;
                            }
                        }) {
                            ZStack(alignment: .topLeading) {
                                ShinyText(text: "< " + weAreInCategory.descriptionChinese, font: "DFPHeiW12-GB", size: 20, textColor: Color("LightGray"))
                            }
                        }
                            .padding(.top, 40)
                            .padding(.leading, 20)

                        Spacer()
                        // todo: center it

                        VStack(alignment: .center) {
                            HStack {
                                Spacer()
                            }
                            HStack(spacing: 30) {
                                Button (action: {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                                        self.lockingSelection = .unlocked
                                    } }
                                ) {
                                    ShinyText(text: LockingSelection.unlocked.description, font: "DFPHeiW12-GB", size: 16, textColor: lockingSelection == .unlocked ? lockingSelection.foregroundColor : Color("LightGray"), shadowColor: lockingSelection == .unlocked ? lockingSelection.foregroundColor : Color("LightGray"))
                                }
                                Button (action: {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                                        self.lockingSelection = .locked
                                    } }
                                ) {
                                    ShinyText(text: LockingSelection.locked.description, font: "DFPHeiW12-GB", size: 16, textColor: lockingSelection == .locked ? lockingSelection.foregroundColor : Color("LightGray"), shadowColor: lockingSelection == .locked ? lockingSelection.foregroundColor : Color("LightGray"))
                                }
                            }
                        }
//                            .padding(.bottom, 5)

                        VStack(alignment: .center) {
//                            HStack {
//                                Spacer()
//                            }
                            HStack(spacing: 30) {
                                Spacer()
                                (lockingSelection == .unlocked ? lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                (lockingSelection == .locked ? lockingSelection.foregroundColor : Color("LightGray").opacity(0)).frame(width: 50, height: 2).offset(y: -3)
                                Spacer()
                            }.background(lockingSelection.backgroundColor)
                                .frame(height: 3)

                        }
                    }


                }


            }
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .shadow(radius: 20)
                .zIndex(1)

            if lockingSelection == .locked {
                FullScroll(lockingSelection: lockingSelection, texts: texts)
                    .frame(width: UIScreen.main.bounds.width)
                    .zIndex(0.5)
            } else {
                FullScroll(lockingSelection: lockingSelection, texts: unlockedTexts)
                    .frame(width: UIScreen.main.bounds.width)
                    .zIndex(0.5)
            }

        }

    }
}

struct FullScroll: View {
    @State var lockingSelection: LockingSelection
    @State var texts: [CardContent]

    var body: some View {
        ScrollView {
            if #available(iOS 14.0, *) {
                LazyVStack {
                    ForEach(texts.indices) { idx in
                        Card(cardContent: self.texts[idx], lockingSelection: $lockingSelection)
                    }
                }
            } else {
                // Fallback on earlier versions
                VStack {
                    ForEach(texts.indices) { idx in
                        Card(cardContent: self.texts[idx], lockingSelection: $lockingSelection)
                    }
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
