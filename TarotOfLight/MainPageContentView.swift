//
//  MainPageContentView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

import SDWebImageSwiftUI

struct MainPageContentView: View {
    var isFull: Bool {
        get {
            return progress >= 100.0
        }
    }
    @State var tideAnimating: Bool = true
    @State var growingAnimating: Bool = true
    @State var grownAnimating: Bool = true
    @Binding var progress: Double
    @State var nowDate: DateComponents = Calendar
        .current
        .dateComponents([
                .year,
                .month,
                .day,
                .hour,
                .minute,
                .second,
                .nanosecond
            ], from: Date())

    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.nowDate = Calendar
                .current
                .dateComponents([
                        .year,
                        .month,
                        .day,
                        .hour,
                        .minute,
                        .second,
                        .nanosecond
                    ], from: Date())
        }
    }
    let tideScale: CGFloat = 1.5

    func randomPositionAroundCircle(size: CGSize) -> CGSize {
        let angle = Double.random(in: 0..<2 * Double.pi)
        let scale = Double.random(in: 0.95..<1.15)
        let radius = Double(min(size.width, size.height))
        return CGSize(width: cos(angle) * radius * scale, height: sin(angle) * radius * scale)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // This image shoulde be at the bottom of the whole screen

            Color("MediumPurple")
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * CGFloat(progress) / 100 - 200))
                .clipShape(RoundedRectangle(cornerRadius: 38))
                .opacity(isFull ? 0 : 1)


            WebImage(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "tide", ofType: "gif") ?? "tide.gif"),
                isAnimating: self.$tideAnimating)
                .resizable()
                .playbackRate(1.0)
                .retryOnAppear(true)
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * self.tideScale)
                .offset(y: UIScreen.main.bounds.height * (100 - CGFloat(progress)) / 100 - 600)
                .opacity(isFull ? 0 : 1)


            Color("MediumDarkPurple")
                .frame(width: UIScreen.main.bounds.width)
                .clipShape(RoundedRectangle(cornerRadius: 38))
                .opacity(self.isFull ? 1 : 0)

            // The main content of navigations, should be changed upon selecting differene pages
            VStack {
                HStack {
                    VStack() {
                        Image("buguang")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120, alignment: .center)
                        HStack(spacing: 0) {
                            Image("power")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .shadow(radius: 2)
                            LittleProgressBar(value: $progress).offset(x: -10)
                        }.offset(x: 10, y: -30)
                    }
                        .padding(.bottom)
                        .padding(.trailing, 20)


                    Button(action: {
                        withAnimation(springAnimation) {
                            self.progress += 30
                            if (self.progress >= 100.0) {
                                self.progress = 100.0
                            }
//                            print("Screen height would be: \(UIScreen.main.bounds.height)")
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(isFull ? Color("MediumPurple") : .white)
                                .frame(width: 100, height: 125)
                                .shadow(radius: 10)
                            VStack {
                                Text("\(String(nowDate.year ?? 2000))年\(String(nowDate.month ?? 7))月")
                                    .onAppear(perform: {
                                        _ = self.timer
//                                        self.tideAnimating = true
//                                        print("Tide animating is set to true")
//                                        print("\(self.tideAnimating)")
                                    })
                                    .foregroundColor(Color("Lime"))
                                    .font(.custom("Source Han Sans Heavy", size: 16))
                                    .offset(y: 10)
                                // Don't create another timer here
                                Text("\(String(nowDate.day ?? 10))")
                                    .foregroundColor(isFull ? Color("Lime") : Color("LightPurple"))
                                    .font(.custom("Source Han Sans Heavy", size: 40))

                                Text("日签")
                                    .foregroundColor(isFull ? Color("Lime") : Color("LightPurple"))
                                    .font(.custom("Source Han Sans Heavy", size: 25))
                                    .background(GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 15)
                                            .strokeBorder(
                                                style: StrokeStyle(
                                                    lineWidth: 2,
                                                    dash: [2]
                                                )
                                            )
                                            .foregroundColor(Color("Lime"))
                                            .frame(width: geometry.size.width * 1.3)
                                    })
                            }.offset(y: -10)
                        }
                            .padding()
                            .offset(y: -5)
                            .padding(.leading, 20)

                    }


                }.padding(.bottom) // Magic Value
                .offset(y: -10)
                    .zIndex(1) // So that daily prediction won't overlay with the shadow

                ZStack {
                    // Current we using one variable for both the plant and the tide
                    // FIXME: change to two

                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plant", ofType: "gif") ?? "plant.gif"),
                        isAnimating: self.$tideAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .background(ComplexCircleBackground(isFull: isFull))
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10)
                        .opacity(isFull ? 0 : 1)
                        .animation(.easeInOut(duration: isFull ? 2.0 : 0.1))

                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "growing", ofType: "gif") ?? "growing.gif"),
                        isAnimating: self.$growingAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .background(ComplexCircleBackground(isFull: isFull))
                        .shadow(color: Color("Lime").opacity(0.3), radius: 10)
                        .opacity(isFull ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.1))


                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "grown", ofType: "gif") ?? "grown.gif"),
                        isAnimating: self.$grownAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .background(ComplexCircleBackground(isFull: isFull))
                        .shadow(color: Color("Lime").opacity(0.3), radius: 10)
                        .opacity(isFull ? 1 : 0)
                        .animation(Animation.easeInOut(duration: 0.1).delay(isFull ? 1.0 : 0))



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
                    .zIndex(0.5)

                if (isFull) {
                    Button(action: {
                        withAnimation(springAnimation) {
                            self.progress -= 30;
                            if (self.progress < 0) {
                                self.progress = 0
                            }
                        }
                    }) {
                        ZStack(alignment: .center) {
                            ShinyText()
                                .background(ComplexCircleBackground(globalScale: 1.5, borderScale: 1.1, shapeShift: 1.0, isCircleBorder: true, innerColor: "MediumLime", outerColor: "LightPink", isFull: false))
                                .padding(.top, 30) // Magic Value
                            .padding(.bottom, 30) // Magic Value
                        }
                    }

                } else {

                    // To use custom font, be sure to have already added them in info.plist
                    // refer to https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app
                    // and: https://medium.com/better-programming/swiftui-basics-importing-custom-fonts-b6396d17424d
                    Text("在时间和光的交汇点")
                        .font(.custom("Source Han Sans Heavy", size: 25))
                        .foregroundColor(Color("MediumLime"))
                    Text("遇见自己")
                        .font(.custom("Source Han Sans Heavy", size: 25))
                        .foregroundColor(Color("MediumLime"))
                }
            }.padding(.bottom, 170) // Magic Value
            
        // STUB: adding a frame width limitation so that the animation wouldn't looking funny
        }.frame(width: UIScreen.main.bounds.width)
    }
}
