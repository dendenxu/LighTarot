//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

// FIXME: format stuff
import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct CardPageContentView: View {
    var body: some View {
        Color(.purple).edgesIgnoringSafeArea(.all)
    }
}


struct MinePageContentView: View {
    var body: some View {
        Color(.blue).edgesIgnoringSafeArea(.all)
    }
}

struct MainPageContentView: View {
    @Binding var tideAnimating: Bool
    @State var progress = 30.0
    @State var nowDate: DateComponents = Calendar
        .current
        .dateComponents([
                .year,
                .month,
                .day,
                .hour,
                .minute
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
                        .minute
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
        ZStack {
            GeometryReader { geometry in
                WebImage(
                    url: URL(fileURLWithPath: Bundle.main.path(forResource: "tide", ofType: "gif") ?? "tide.gif"),
                    isAnimating: self.$tideAnimating)
                    .resizable()
                    .playbackRate(1.0)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * self.tideScale)
                    .offset(x: -geometry.size.width * (self.tideScale-1) / 2, y: geometry.size.height * 7 / 9)
                    .edgesIgnoringSafeArea(.all)
                    .transition(fromBottomToTop)
            }

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
                        .padding()
                        .padding(.trailing, 20)


                    Button(action: { }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
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
                                    .foregroundColor(Color(hex: 0xa8eb00))
                                    .font(.custom("Source Han Sans Heavy", size: 16))
                                    .offset(y: 10)
                                // Don't create another timer here
                                Text("\(String(nowDate.day ?? 10))")
                                    .foregroundColor(Color(hex: 0xe000c4))
                                    .font(.custom("Source Han Sans Heavy", size: 40))

                                Text("日签")
                                    .foregroundColor(Color(hex: 0xe000c4))
                                    .font(.custom("Source Han Sans Heavy", size: 25))
                                    .background(GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 15)
                                            .strokeBorder(
                                                style: StrokeStyle(
                                                    lineWidth: 2,
                                                    dash: [2]
                                                )
                                            )
                                            .foregroundColor(Color(hex: 0xa8eb00))
                                            .frame(width: geometry.size.width * 1.3)
                                    })
                            }.offset(y: -10)
                        }
                            .padding()
                            .offset(y: -5)
                            .padding(.leading, 20)

                    }


                }.padding(.top, 40)

                ZStack {
                    // Current we using one variable for both the plant and the tide
                    // FIXME: change to two
                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plant", ofType: "gif") ?? "plant.gif"),
                        isAnimating: self.$tideAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .background(ComplexCircleBackground())
                        .shadow(radius: 10)
                        .transition(fromBottomToTop)

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

                // To use custom font, be sure to have already added them in info.plist
                // refer to https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app
                // and: https://medium.com/better-programming/swiftui-basics-importing-custom-fonts-b6396d17424d
                Text("在时间和光的交汇点")
                    .font(.custom("Source Han Sans Heavy", size: 25))
                    .foregroundColor(Color(hex: 0x38ed90))
                Text("遇见自己")
                    .font(.custom("Source Han Sans Heavy", size: 25))
                    .foregroundColor(Color(hex: 0x38ed90))
            }.padding(.bottom, 200)

        }
    }
}

let fromBottomToTop = AnyTransition
    .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom))
    .animation(.easeInOut(duration: 2))

struct ContentView: View {
    @State var weAreIn = Pages.mainPage
    @State var tideAnimating = true


    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color: a small shade of grey, filling the whole screen
            Color(hex: 0xf2f2f2).edgesIgnoringSafeArea(.all)
            // Background tidal wave as GIF, we use SDWebImageSwiftUI to load and use GIF

            if (weAreIn == Pages.mainPage) {
                MainPageContentView(tideAnimating: $tideAnimating)
                    .transition(fromBottomToTop)
                    .onDisappear() {
                        print("MainPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
                        self.tideAnimating = false
                    }.onAppear() {
                        print("MainPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.cardPage) {
                CardPageContentView()
                    .transition(fromBottomToTop)
                    .onDisappear() {
                        print("CardPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
                        self.tideAnimating = true
                    }.onAppear() {
                        print("CardPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.minePage) {
                MinePageContentView()
                    .transition(fromBottomToTop)
            }


            // The page selector, should remain if we're only navigating around different pages
            // And it should go when the scene is completely changed
            PageSelector(weAreIn: $weAreIn).padding(.bottom, 50)
        }
    }
}

// A small progress bar, cool, right?
struct LittleProgressBar: View {
    @Binding var value: Double
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(width: 100, height: 10)
                .opacity(0.5)
                .foregroundColor(Color(hex: 0xffffff))
            Rectangle().frame(width: CGFloat(self.value), height: 10)
                .foregroundColor(Color(hex: 0xa8eb00))
        }
            .cornerRadius(45.0)
            .shadow(radius: 5)
            .padding()
    }
}

// Some randomized shiny star with shiny animations
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
        // Note that the declarative statement takes effect one by one
        // For example we can add two rotation effect just by adding the offset before and after the offset change
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

// Complex background, you know we should consider usingg ZStack in this situation
// We've only created this so that we can hold scales as variables
// Should be more configurable if it's to remain
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

// Using hex directly
// NOT A GOOD PRACTICE
// FIXME: consider adding colors to xcassets
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

// Previewer
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}

// Page changer
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

// The page selector view with slightly tailored edge
struct PageSelector: View {
    @Binding var weAreIn: Pages
    var body: some View {
        HStack {
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.mainPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.cardPage)
            PageSelectorButton(weAreIn: $weAreIn, whoWeAre: Pages.minePage)
        }
            .padding()
            .background(Color.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

// Buttons in the page selector, using enum to avoid raw string
// which could lead to typo that compiler cannot foresee
struct PageSelectorButton: View {
    @Binding var weAreIn: Pages
    let whoWeAre: Pages
    var body: some View {
        Button(action: {
            withAnimation {
                self.weAreIn = self.whoWeAre
            }
        }) {
            Image(String(describing: whoWeAre) + ((weAreIn == whoWeAre) ? "Material" : ""))
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .shadow(radius: 10)
        }.padding(.horizontal, 20)
    }
}
