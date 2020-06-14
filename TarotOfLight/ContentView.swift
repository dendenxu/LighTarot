//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct ContentView: View {
    @State var catAnimating: Bool = true
    @State var tideAnimating: Bool = true
    @State var weAreIn = Pages.mainPage
    @State var progress = 30.0

    let tideScale: CGFloat = 1.5

    func randomPositionAroundCircle(size: CGSize) -> CGSize {
        let angle = Double.random(in: 0..<2 * Double.pi)
        let scale = Double.random(in: 0.95..<1.15)
        let radius = Double(min(size.width, size.height))
        return CGSize(width: cos(angle) * radius * scale, height: sin(angle) * radius * scale)
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            Color(hex: 0xf2f2f2).edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                WebImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "tide", ofType: "gif") ?? "tide.gif"), isAnimating: self.$tideAnimating)
                    .resizable()
                    .playbackRate(1.0)
                    .scaledToFit()
                    .frame(width: geometry.size.width * self.tideScale, height: geometry.size.height * self.tideScale, alignment: .bottom)
                    .offset(x: -geometry.size.width * (self.tideScale-1) / 2)
                    .edgesIgnoringSafeArea(.all)
            }


            VStack {

                HStack {
                    VStack() {
                        Image("buguang").renderingMode(.original).resizable().scaledToFit().frame(width: 120, height: 120, alignment: .center)
                        HStack(spacing: 0) {
                            Image("power").renderingMode(.original).resizable().scaledToFit().frame(width: 20, height: 20).shadow(radius: 2)
                            LittleProgressBar(value: $progress).offset(x: -10)
                        }.offset(x: 10, y: -30)
                    }.padding()
                    Text("Take your guess everyday")
                }.padding(.top, 40)

                ZStack {
                    WebImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "plant", ofType: "gif") ?? "plant.gif"), isAnimating: self.$tideAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .background(ComplexCircleBackground())
                        .shadow(radius: 10)

                    ForEach(0..<5) { number in
                        ShinyStar(
                            offset: self.randomPositionAroundCircle(
                                size: CGSize(
                                    width: 350 / 2,
                                    height: 350 / 2)),
                            scale: CGFloat.random(in: 0.9..<1.1)
                        )
                    }
                }.offset(y: -20)

                Text("在时间和光的交汇点").font(.custom("Source Han Sans Heavy", size: 25)).foregroundColor(Color(hex: 0x38ed90))
                Text("遇见自己").font(.custom("Source Han Sans Heavy", size: 25)).foregroundColor(Color(hex: 0x38ed90))
            }


            PageSelector(weAreIn: $weAreIn).padding(.bottom, 50)
        }
    }
}


struct LittleProgressBar: View {
    @Binding var value: Double
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(width: 100, height: 10)
                .opacity(0.3)
                .foregroundColor(Color(hex: 0xffffff))
            Rectangle().frame(width: CGFloat(self.value), height: 10)
                .foregroundColor(Color(hex: 0xa8eb00))
        }.cornerRadius(45.0).shadow(radius: 5).padding()
    }
}

struct ShinyStar: View {
    let offset: CGSize
    let scale: CGFloat
    @State var isAtMaxScale = false
    let maxScale: CGFloat = 1.5
    var shineAnimation = Animation
        .easeInOut(duration: 1)
        .repeatForever(autoreverses: true)
        .delay(Double.random(in: 0..<1))
    var body: some View {
        Image("star")
            .resizable()
            .scaledToFit()
            .shadow(color: Color.purple, radius: 5)
            .opacity(isAtMaxScale ? 1 : 0)
            .scaleEffect(isAtMaxScale ? maxScale : 0.5)
            .rotationEffect(isAtMaxScale ? .degrees(60) : .degrees(0))
            .onAppear() {
                withAnimation(self.shineAnimation) {
                    self.isAtMaxScale.toggle()
                }
            }
            .frame(width: 30 * scale, height: 30 * scale, alignment: .center)
            .offset(offset)
            .rotationEffect(isAtMaxScale ? .degrees(30) : .degrees(0))
    }
}

struct ComplexCircleBackground: View {
    let globalScale: CGFloat = 0.95
    let borderScale: CGFloat = 1.05
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .strokeBorder(
                    style: StrokeStyle(
                        lineWidth: 2,
                        dash: [2]
                    )
                )
                .foregroundColor(Color(hex: 0xe000c4))
                .frame(width: geometry.size.width * self.borderScale * self.globalScale, height: geometry.size.height * self.borderScale * self.globalScale)
                .offset(x: -geometry.size.width * (self.borderScale * self.globalScale-1) / 2, y: -geometry.size.height * (self.borderScale * self.globalScale-1) / 2)
            Circle()
                .fill(Color(hex: 0xa8eb00))
                .frame(width: geometry.size.width * self.globalScale, height: geometry.size.height * self.globalScale)
                .offset(x: -geometry.size.width * (self.globalScale-1) / 2, y: -geometry.size.height * (self.globalScale-1) / 2)
        }
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
                .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}

enum Pages: CustomStringConvertible {
    var description: String {
        switch self {
        case .mainPage: return "mainPage"
        case .cardPage: return "cardPage"
        case .minePage: return "minePage"
        }
    }

    case mainPage
    case cardPage
    case minePage
}

struct PageSelector: View {
    @Binding var weAreIn: Pages
    var body: some View {
        HStack {
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.mainPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.cardPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.minePage)
        }.padding().background(Color.white.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

struct PageSelectorButton: View {
    @Binding var weAreIn: Pages
    let whoWeAre: Pages
    var body: some View {
        Button(action: {
            self.weAreIn = self.whoWeAre
        }) {
            Image(String(describing: whoWeAre) + ((weAreIn == whoWeAre) ? "Material" : "")).renderingMode(.original).resizable().scaledToFit().frame(height: 50).shadow(radius: 10)
        }.padding(.horizontal, 20)
    }
}
