//
//  CardPageContentView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct CardPageContentView: View {

    var body: some View {
//        ZStack(alignment: .center) {
//            ShinyText(text: "让我们看看是谁的字体还没换过来", font: "DFPHeiW12-GB", size: 20, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime").opacity(0.75), isScaling: true)
//        }
        VStack() {
            VStack(alignment: .leading) {
                ShinyText(text: "卜光牌阵", font: "DFPHeiW12-GB", size: 40, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true).padding(.bottom).padding(.top, 60)
                ShinyText(text: "让塔罗和光给予你最善意的指引", font: "DFPHeiW12-GB", size: 20, maxScale: 1.5, textColor: Color("MediumLime").opacity(0.65), shadowColor: Color("Lime"), isScaling: true)

            }.offset(x: -30)

            VStack {
                HStack {
                    CategorySelectorView()
                    CategorySelectorView()
                }.padding(.top)
                HStack {
                    CategorySelectorView()
                    CategorySelectorView()
                }.padding(.bottom)
            }.padding(.horizontal, 20)


            Spacer(minLength: 180)
        }.background(ShinyBackground(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
    }
}


struct CategorySelectorView: View {
    var body: some View {
        Button(action: {

        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 38).foregroundColor(Color("LightMediumDarkPurple"))
                ShinyText(text: "I'm a dummy Text", font: "DFPHeiW12-GB", size: 30, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"), isScaling: true)
            }.shadow(radius: 20).padding()
        }
    }
}
