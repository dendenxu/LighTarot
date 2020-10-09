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

    @State var image: Image? = Image("head")
    @State var showImagePicker: Bool = false
    var body: some View {
        VStack {
            VStack { // FIXME: why do we need this?
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
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
                        .padding(.top, 150)
                }
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.image = Image(uiImage: image)
                    print("Avatar set to new image")
                }
            }
            Spacer()
            ShinyText(text: "小土豆", font: "DFPHeiW12-GB", size: 30, textColor: Color.black.opacity(0.75), shadowColor: Color.black.opacity(0.3))
                .padding(.top, 10)
            textField(text: "出生时间", placeholder: "出生时间", imageName: "time")
                .padding(.top, 30)

            textField(text: "现居地", placeholder: "现居地", imageName: "location")
                .padding(.top, 30)

            Text("资料完整度越高，占卜越真实哦！")
                .font(.custom("Source Han Sans Medium", size: 15))
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.top, 30)
                .padding(.bottom, 200)


        }
    }
}

struct textField: View {
    @State var text = "现居地"
    @State var placeholder = "Placeholder"
    var imageName = "location"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38)
                .foregroundColor(.white)
            HStack {
                TextField(placeholder, text: $text, onEditingChanged: { editing in
                    print("Editing TextField Change: \(text), editing: \(editing)")
                    if editing == false { text = placeholder }
                }, onCommit: { placeholder = text })
                    .font(.custom("Source Han Sans Medium", size: 16))
                    .foregroundColor(Color.black.opacity(0.4))
                    .padding(.leading, 10)
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (imageName == "location") ? 25 : 20, height: (imageName == "location") ? 25 : 20)
                    .offset(x: (imageName == "location") ? 2 : 0)
            }.padding()
        }.frame(width: 200, height: 40)
    }
}