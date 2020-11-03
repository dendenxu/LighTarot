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

struct RoundRecBackground: View {
    var body: some View {

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

struct MainPageView: View {
    @EnvironmentObject var profile: LighTarotModel
    var isFull: Bool {
        get {
            return progress >= 100.0
        }
    }
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

    @State var debugTimer: Timer?
    let plantRadius = 350 / 414 * .ScreenWidth
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
            } else {
                ZStack {
                    LottieView(name: "tide", loopMode: .loop)
                        .frame(width: .ScreenWidth, height: .ScreenHeight * 2)
                        .scaledToFit()
                        .scaleEffect(tideScale)
                        .offset(y: .ScreenHeight + 50) // MARK: Magic value
                    .offset(y: -.ScreenHeight * (CGFloat(progress)) / 100)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                            print("Moving back to the foreground!")
//                            lottieView.shouldPlay = true
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                            print("Moving to the background!")
//                            lottieView.shouldPlay = false

                    }
                }.frame(width: .ScreenWidth, height: .ScreenHeight)
            }

            // The main content of navigations, should be changed upon selecting differene pages
            VStack {
                HStack(spacing: 50) { // The top two objects
                    VStack(spacing: 0) { // The energy bar
                        Button(action: {

                            withAnimation(springAnimation) {
                                profile.shouldShowEnergy.toggle()
                            }
                            print("ShouldShowEnergy of the model set to \(profile.shouldShowEnergy)!")

                        }) {
//                            Image.default("buguang")
//                                .frame(width: 120, height: 120)
//                                .shadow(color: Color("MediumLime").opacity(0.3), radius: 5)

                            ShinyText(text: "卜光", font: .DefaultChineseFont, size: 55, textColor: Color("MediumLime"), shadowColor: Color("MediumLime").opacity(0.3), shadowRadius: 5)
//                                .scaledToFit()

//                                .background(Rectangle().opacity(0.3))
//                                .frame(width: 120)
//                                .padding(.bottom, 10)
                        }.buttonStyle(LongPressButtonStyle(color: .red))

//                        Button(action: {
//
//
//                        }) {
                        ZStack {
                            if profile.proficientUser {
                                HStack(spacing: 0) {
                                    Image.default("power")
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 2)
                                    LittleProgressBar(value: progress)
                                        .frame(width: 100, height: 15)
                                        .padding()
                                        .offset(x: -10)
                                }.offset(x: 10)
                            }
                            else {
                                ShinyText(text: "AR捕光塔罗", font: .SourceHanSansLight, size: 18, textColor: Color("MediumLime"))
//                                        .background(Rectangle().opacity(0.3))
                            }
                        }
                            .offset(x: 5)
//                        }.buttonStyle(LongPressButtonStyle(color: .red))
                    }


                    Button(action: { // The Daily
                        profile.complexSuccess()
                        withAnimation(springAnimation) {
                            progress += 20
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(isFull ? Color("MediumPurple") : .white)
                                .shadow(radius: 5)
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

                                Button(action: {
                                    print("Am I a proficient user: \(profile.proficientUser)")
                                    withAnimation(springAnimation) {
                                        profile.proficientUser.toggle()
                                    }
                                    print("PROFICIENT: Setting you to a proficient user? : \(profile.proficientUser)")
                                }) {
                                    Text("日签")
                                        .foregroundColor(isFull ? Color("Lime") : Color("LightPurple"))
                                        .font(.custom(.SourceHanSansHeavy, size: 25))
                                        .overlay(RoundRecBackground())
                                }.buttonStyle(LongPressButtonStyle(color: .red))



                                Spacer()
                            }
                        }.frame(width: 100, height: 125)
                    }
                }
                    .zIndex(1) // So that daily prediction won't overlay with the shadow
                .padding(.top, 90 - 20 * CGFloat(progress) / 100)
                    .padding(.bottom, 30)


                Button(action: {
                    withAnimation(springAnimation) {
                        progress -= 50
                    }
                }) {

                    ZStack {
                        AnimatingPlant(isFull: isFull, onMe: profile.shouldShowEnergy, grownAnimating: $grownAnimating)
                            .zIndex(0.5)
                            .frame(width: plantRadius, height: plantRadius)
                            .padding(.bottom, 20 + 10 * CGFloat(progress) / 100)
                        // MARK: Just using 233 as fixed value, hoping it could work
//                            .background(
//                                ZStack {
//                                    GeometryReader {
//                                        geo in
//                                        Spacer()
//                                            .onAppear {
//                                                debugTimer?.invalidate()
//                                                debugTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                                                    print("Currently getting size: \(geo.size) and position: \(geo.frame(in: .global)) and local: \(geo.frame(in: .local))")
//                                                }
//                                            }
//                                    }
//                                }
//                            )
                    }

//                        .overlay()


                    // FIXME: Guess this would be a BUG of SwiftUI right? When using progress: Double directly, the Swift compiler cannot determine the return value of the whole stack(which is quite common in SwiftUI bug)
                    // FIXME: When we're using too large an offset, like .offset(y: CGFloat(progress)) directly, the Swift compiler crashes, returning non-zero value

                }.buttonStyle(LongPressButtonStyle(color: .red))




                if (isFull) {
                    Button(action: {
                        withAnimation(springAnimation) {
                            progress -= 50
                        }
                    }) {
                        ShinyText(text: "解锁新牌阵").frame(width: 100, height: 100)
                            .background(ComplexCircleBackground(shapeShift: 1.0, isCircleBorder: true, innerColor: "MediumLime", outerColor: "LightPink", isFull: false))
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
