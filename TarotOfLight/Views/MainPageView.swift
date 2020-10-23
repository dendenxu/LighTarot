//
//  MainPageView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import Lottie
import SDWebImageSwiftUI

func randomPositionAroundCircle(size: CGSize) -> CGSize {
    let angle = Double.random(in: 0..<2 * Double.pi)
    let scale = Double.random(in: 0.95..<1.15)
    let radius = Double(min(size.width, size.height))
    return CGSize(width: cos(angle) * radius * scale, height: sin(angle) * radius * scale)
}

struct MyRecBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [2]
                        )
                    )
                    .foregroundColor(Color("Lime"))
                    .scaleEffect(x: 1.3, y: 1, anchor: .center)
            }
        }
    }
}

struct MainPageView: View {
    var isFull: Bool {
        get {
            return progress >= 100.0
        }
    }
    @State var tideAnimating: Bool = true
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
    let tideScale: CGFloat = 1.05


    var body: some View {
        ZStack() {

            // background image
            // This image shoulde be at the bottom of the whole screen


            if (isFull) {
                RoundedRectangle(cornerRadius: .ScreenCornerRadius)
                    .foregroundColor(Color("MediumDarkPurple"))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } else {
                ZStack{
                    LottieView(name: "tide", loopMode: .loop)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
                        .scaledToFit()
                        .scaleEffect(tideScale)
                        .offset(y: UIScreen.main.bounds.height)
                        .offset(y: -UIScreen.main.bounds.height * (CGFloat(progress)) / 100)
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }

            // The main content of navigations, should be changed upon selecting differene pages
            VStack {
                HStack(spacing: 40) { // The top two objects
                    VStack(alignment: .center) { // The energy bar
                        Image("buguang")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .shadow(color: Color("MediumLime").opacity(0.3), radius: 5)
                        HStack(spacing: 0) {
                            Image("power")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .shadow(radius: 2)
                            LittleProgressBar(value: progress)
                                .frame(width: 100, height: 15)
                                .padding()
                                .offset(x: -10)
                        }.offset(x: 10, y: -30)
                    }


                    Button(action: { // The Daily
                        withAnimation(springAnimation) {
                            self.progress += 20
                            if (self.progress >= 100.0) {
                                self.progress = 100.0
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(isFull ? Color("MediumPurple") : .white)
                                .shadow(radius: 10)
                            VStack {
                                Text("\(String(nowDate.year ?? 2000))年\(String(nowDate.month ?? 7))月")
                                    .onAppear(perform: {
                                        _ = self.timer
                                    })
                                    .foregroundColor(Color("Lime"))
                                    .font(.custom(.SourceHanSansHeavy, size: 15))
                                    .padding(.top, 10)
                                // Don't create another timer here
                                Text("\(String(nowDate.day ?? 10))")
                                    .foregroundColor(isFull ? Color("Lime") : Color("LightPurple"))
                                    .font(.custom(.SourceHanSansHeavy, size: 40))

                                Text("日签")
                                    .foregroundColor(isFull ? Color("Lime") : Color("LightPurple"))
                                    .font(.custom(.SourceHanSansHeavy, size: 25))
                                    .overlay(MyRecBackground())

                                Spacer()
                            }
                        }.frame(width: 100, height: 125)
                    }
                }.zIndex(1) // So that daily prediction won't overlay with the shadow
                .padding(.top, 80 - 20 * CGFloat(progress) / 100)


                AnimatingPlant(progress: progress, tideAnimating: $tideAnimating, growingAnimating: $grownAnimating, grownAnimating: $grownAnimating)
                    .zIndex(0.5)
                // FIXME: Guess this would be a BUG of SwiftUI right? When using progress: Double directly, the Swift compiler cannot determine the return value of the whole stack(which is quite common in SwiftUI bug)
                // FIXME: When we're using too large an offset, like .offset(y: CGFloat(progress)) directly, the Swift compiler crashes, returning non-zero value
                .padding(.bottom, 20 + 10 * CGFloat(progress) / 100)


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
                            ComplexCircleBackground(shapeShift: 1.0, isCircleBorder: true, innerColor: "MediumLime", outerColor: "LightPink", isFull: false)
                                .frame(width: 100, height: 100)
                            ShinyText()
                        }
                    }
                } else {

                    // To use custom font, be sure to have already added them in info.plist
                    // refer to https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app
                    // and: https://medium.com/better-programming/swiftui-basics-importing-custom-fonts-b6396d17424d
                    Text("在时间和光的交汇点")
                        .font(.custom(.SourceHanSansMedium, size: 20))
                        .foregroundColor(Color("MediumLime"))

                    Text("遇见自己，遇见治愈")
                        .font(.custom(.SourceHanSansMedium, size: 20))
                        .foregroundColor(Color("MediumLime"))
                        .padding(.bottom, 20)
                }
                Spacer()
            }
        }
    }
}

struct AnimatingPlant: View {
    var progress: Double
    var isFull: Bool {
        get {
            return progress >= 100.0
        }
    }
    @Binding var tideAnimating: Bool
    @Binding var growingAnimating: Bool
    @Binding var grownAnimating: Bool
    var body: some View {
        ZStack {
            // Current we using one variable for both the plant and the tide
            // FIXME: change to two
            WebImage(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "grown", ofType: "gif") ?? "grown.gif"),
                isAnimating: self.$grownAnimating)
                .resizable()
                .playbackRate(1.0)
                .retryOnAppear(true)
                .scaledToFill()
                .frame(width: 350, height: 350)
                .background(ComplexCircleBackground(isFull: isFull))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10)
            ForEach(0..<5) { number in
                ShinyStar(
                    offset: randomPositionAroundCircle(
                        size: CGSize(
                            width: 350 / 2,
                            height: 350 / 2)),
                    scale: CGFloat.random(in: 0.9..<1.1)
                )
            }
        }
    }
}
