//
//  CategoryView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @Binding var weAreInCategory: CategorySelection
    @Binding var weAreInGlobal: GlobalViewSelection
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 120)
                        .foregroundColor(Color("LightMediumDarkPurple"))
                    Button(action: {
                        withAnimation(springAnimation) {
                            self.weAreInGlobal = .selector;
                        }
                    }) {
                        ShinyText(text: "< " + weAreInCategory.descriptionChinese, font: "DFPHeiW12-GB", size: 20, textColor: Color("LightGray"))
                            .offset(x: 25, y: 10)
                    }
                }
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 3)
                    .foregroundColor(Color("MediumLime"))
            }.shadow(radius: 20)
                .zIndex(1)

            ScrollView {
                VStack() {
                    ShinyText(text: "I'm a placeholder", font: "DFPHeiW12-GB", size: 40, maxScale: 1.5, textColor: Color("MediumLime"), shadowColor: Color("Lime"))
                }
            }.background(Color("LightGray").frame(width: UIScreen.main.bounds.width))
                .zIndex(0.5)
        }

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
