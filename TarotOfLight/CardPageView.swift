//
//  CardPageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct CardPageView: View {
    @Binding var weAreInGlobal: GlobalViewSelection
    @Binding var weAreInCategory: CategorySelection
    var body: some View {

        VStack() {
            VStack(alignment: .leading) {
                ShinyText(text: "卜光牌阵", font: .DefaultChineseFont, size: 40, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                    .padding(.bottom)
                    .padding(.top, 60)
                    .background(
                        ShinyBackground(
                            size: CGSize(
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height
                            )
                        )
                    )
                ShinyText(text: "让塔罗和光给予你最善意的指引", font: .DefaultChineseFont, size: 20, maxScale: 1.5, textColor: Color("MediumLime").opacity(0.65), shadowColor: Color("Lime"), isScaling: true)

            }.offset(x: -30)

            VStack {
                HStack {
                    CategorySelectorView(weAreInGlobal: self.$weAreInGlobal, weAreInCategory: self.$weAreInCategory, whoWeAre: .love)
                    CategorySelectorView(weAreInGlobal: self.$weAreInGlobal, weAreInCategory: self.$weAreInCategory, whoWeAre: .career)
                }.padding(.top)
                HStack {
                    CategorySelectorView(weAreInGlobal: self.$weAreInGlobal, weAreInCategory: self.$weAreInCategory, whoWeAre: .wealth)
                    CategorySelectorView(weAreInGlobal: self.$weAreInGlobal, weAreInCategory: self.$weAreInCategory, whoWeAre: .relation)
                }.padding(.bottom)
            }.padding(.horizontal, 20)
        }.padding(.bottom, 200)
    }
}


struct CategorySelectorView: View {
    @Binding var weAreInGlobal: GlobalViewSelection
    @Binding var weAreInCategory: CategorySelection
    @State var isButtonReleased = false
    var whoWeAre = CategorySelection.love
    var imageScale: CGFloat = 0.7
    var body: some View {
        GeometryReader {
            geometry in
            Button(action: {
                withAnimation(springAnimation) {
                    self.weAreInGlobal = .predictLight
                    self.weAreInCategory = self.whoWeAre
                    self.isButtonReleased = true
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: .ScreenCornerRadius).foregroundColor(Color("LightMediumDarkPurple"))
                    VStack(alignment: .center) {
                        Image(self.whoWeAre.description)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * self.imageScale, height: geometry.size.height * self.imageScale)
                            .shadow(color: Color("Lime"), radius: 5)
                            .offset(x: 0, y: 0)
                        ShinyText(text: self.whoWeAre.descriptionChinese, font: .DefaultChineseFont, size: 20, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                            .padding(.bottom, 30)

                    }
                }.shadow(radius: 20).padding()
            }
        }
    }
}

