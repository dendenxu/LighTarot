//
//  CardPageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                ShinyText(text: "卜光牌阵", font: .DefaultChineseFont, size: 40, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                    .padding(.bottom)
                    .padding(.top, 60)
                    .background(
                        ShinyBackground(
                            size: CGSize(
                                width: .ScreenWidth,
                                height: .ScreenHeight
                            ),
                            tintColor: Color("LightMediumDarkPurple")
                        )
                    )
                ShinyText(text: "让塔罗和光给予你最善意的指引", font: .SourceHanSansMedium, size: 20, maxScale: 1.5, textColor: Color("MediumLime").opacity(0.65), shadowColor: Color("Lime"), isScaling: true)
                ShinyText(text: "选择一种塔罗牌阵开启捕光旅程", font: .SourceHanSansMedium, size: 20, maxScale: 1.5, textColor: Color("MediumLime").opacity(0.65), shadowColor: Color("Lime"), isScaling: true)

            }.offset(x: -30)

            VStack {
                HStack {
                    CategorySelectorView(whoWeAre: .love)
                    CategorySelectorView(whoWeAre: .career)
                }.padding(.top)
                HStack {
                    CategorySelectorView(whoWeAre: .wealth)
                    CategorySelectorView(whoWeAre: .relation)
                }.padding(.bottom)
            }.padding(.horizontal, 20)
        }.padding(.bottom, 200)
    }
}


struct CategorySelectorView: View {
    @EnvironmentObject var profile: LighTarotModel

    @State var isButtonReleased = false
    var whoWeAre = CategorySelection.love
    var imageScale: CGFloat = 0.5
    var body: some View {
        GeometryReader {
            geometry in
            Button(action: {
                profile.complexSuccess()
                withAnimation(springAnimation) {
                    profile.navigator.weAreInGlobal = .predictLight
                    profile.navigator.weAreInCategory = whoWeAre
                    isButtonReleased = true
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: .ScreenCornerRadius).foregroundColor(Color("LightMediumDarkPurple"))
                    VStack(alignment: .center) {
                        Image.default(whoWeAre.description)
                            .frame(width: geometry.size.width * imageScale, height: geometry.size.height * imageScale)
                            .shadow(color: Color("Lime"), radius: 5)
                            .padding(.vertical, 10)
                        ShinyText(text: self.whoWeAre.descriptionChinese, font: .DefaultChineseFont, size: 20, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                            .padding(.bottom, 30)
                    }
                }.shadow(radius: 20).padding()
            }
        }
    }
}

