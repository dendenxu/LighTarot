//
//  MinePageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI


struct MinePageView: View {
    @EnvironmentObject var profile: UserProfile
    var image: Image {
        print("Using precomputed image to speed things up")
        return Image(uiImage: profile.avatarImage)
    }
    @State var showImagePicker: Bool = false
    @State var keyboardHeight: CGFloat = 0
    @State var currentHeight: CGFloat = 0
//    @State var keyboardUp = [false, false, false]
//    var goodHeight: CGFloat {
//        if keyboardUp[0] {
//            return currentHeight - keyboardHeight
//        } else {
//            return 0
//        }
//    }
    var body: some View {
        VStack {
            VStack { // FIXME: why do we need this?
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    image
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
                                ),
                                tintColor: Color("LightMediumDarkPurple").opacity(0.5)
                            )
                        )
                        .padding(.top, 150)
                }
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    profile.avatar = image.toBase64()
                    print("Avatar set to new image")
                }
            }
            Spacer()
            ShinyText(font: .DefaultChineseFont, size: 30, textColor: Color.black.opacity(0.75), shadowColor: Color.black.opacity(0.3), editable: true, editableText: $profile.name, placeholder: profile.name)
                .frame(width: 200, height: 40)
                .padding(.top, 10)
//                .onReceive(Publishers.keyboardHeight) {
//                    keyboardHeight = $0
//            }
            textField(text: $profile.birthday, placeholder: profile.birthday, imageName: "time")
                .frame(width: 200, height: 40)
                .padding(.top, 30)
//                .onReceive(Publishers.keyboardHeight) {
//                    keyboardHeight = $0
//            }
            textField(text: $profile.location, placeholder: profile.location, imageName: "location")
                .frame(width: 200, height: 40)
                .padding(.top, 30)
//                .onReceive(Publishers.keyboardHeight) {
//                    keyboardHeight = $0
//            }

            Text("资料完整度越高，占卜越真实哦！")
                .font(.custom(.SourceHanSansMedium, size: 15))
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.top, 30)
                .padding(.bottom, 200)


        }
    }
}

struct textField: View {
    @Binding var text: String
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
                    .font(.custom(.SourceHanSansMedium, size: 16))
                    .foregroundColor(Color.black.opacity(0.4))
                    .padding(.leading, 10)
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (imageName == "location") ? 25 : 20, height: (imageName == "location") ? 25 : 20)
                    .offset(x: (imageName == "location") ? 2 : 0)
            }.padding()
        }
    }
}
