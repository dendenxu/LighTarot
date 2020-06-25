//
//  CardPageContentView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct CardPageContentView: View {
    @Binding var weAreInGlobal: GlobalViewSelection
    @Binding var weAreInCategory: CategorySelection
    var body: some View {

        VStack() {
            VStack(alignment: .leading) {
                ShinyText(text: "卜光牌阵", font: "DFPHeiW12-GB", size: 40, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                    .padding(.bottom)
                    .padding(.top, 60)
                    .background(
                        ShinyBackground(
                            // FIXME: this is dirty...
//                            rotationCenter: UnitPoint(x: 0.265, y: 0.11),
//                            rotationCenter: UnitPoint(x: 0, y: 0),
                            size: CGSize(
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height
                            )
                        )
                    )
                ShinyText(text: "让塔罗和光给予你最善意的指引", font: "DFPHeiW12-GB", size: 20, maxScale: 1.5, textColor: Color("MediumLime").opacity(0.65), shadowColor: Color("Lime"), isScaling: true)

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

        }
            .padding(.bottom, 200)
    }
}


struct CategorySelectorView: View {
    @Binding var weAreInGlobal: GlobalViewSelection
    @Binding var weAreInCategory: CategorySelection
    var whoWeAre = CategorySelection.love
    var imageScale: CGFloat = 0.7
    var body: some View {
        Button(action: {
            withAnimation(springAnimation) {
                self.weAreInGlobal = .predictLight
                self.weAreInCategory = self.whoWeAre
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 38).foregroundColor(Color("LightMediumDarkPurple"))
                VStack {
                    GeometryReader {
                        geometry in
                        Image(self.whoWeAre.description)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * self.imageScale, height: geometry.size.height * self.imageScale)
                            .shadow(color: Color("Lime"), radius: 5)
//                            .offset(y: -15)
                    }

                    ShinyText(text: whoWeAre.descriptionChinese, font: "DFPHeiW12-GB", size: 20, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
                        .offset(y: -30)
                }
            }.shadow(radius: 20).padding()
        }
    }
}
