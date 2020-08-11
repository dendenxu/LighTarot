//
//  MinePageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct MinePageView: View {
    @State var tudouAnimating = true
    var body: some View {
//        Color("LightGray").clipShape(RoundedRectangle(cornerRadius: 38))
        VStack {
            Spacer(minLength: 50)

            HStack {
                Spacer()
//                Text("Edit")
                Image("edit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
            }.padding(.trailing, 30)

            Spacer(minLength: 100)

            ZStack {
                WebImage(
                    url: URL(fileURLWithPath: Bundle.main.path(forResource: "tudou", ofType: "gif") ?? "tudou.gif"),
                    isAnimating: self.$tudouAnimating)
                    .resizable()
                    .playbackRate(1.0)
                    .retryOnAppear(true)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .background(

                        ShinyBackground(
                            nStroke: 30, nFill: 15,
                            size: CGSize(
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height
                            )
                        ).opacity(0.5)

                    )
            }


            Spacer(minLength: 10)

            ShinyText(text: "小土豆", font: "DFPHeiW12-GB", size: 30, textColor: Color.black.opacity(0.75), shadowColor: Color.black.opacity(0.3))

            textField(text: "出生时间", imageName: "time")
                .padding(.top, 30)


            textField(text: "现居地", imageName: "location")
                .padding(.top, 30)

            Text("资料完整度越高，占卜越真实哦！")
                .font(.custom("Source Han Sans Medium", size: 15))
                .opacity(0.25)
                .padding()
            Spacer(minLength: 200)
        }
    }
}

struct textField: View {
    var text = "现居地"
    var imageName = "location"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38)
                .foregroundColor(.white)
            HStack {
                Text(text)
                    .font(.custom("Source Han Sans Medium", size: 16))
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                    .opacity(0.2)
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (imageName == "location") ? 25 : 20, height: (imageName == "location") ? 25 : 20)
                    .offset(x: (imageName == "location") ? 2 : 0)
            }.padding()
        }.frame(width: 200, height: 40)
//            .shadow(radius: 5)

    }
}
