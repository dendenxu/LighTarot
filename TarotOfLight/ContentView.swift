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
    @Binding var plantFullAnimating: Bool

    var body: some View {
        // Why do we have to make it inside some stack for it to be loaded?
        ZStack {
            Color("DarkPurple").clipShape(RoundedRectangle(cornerRadius: 38))
            WebImage(
                url: URL(fileURLWithPath: Bundle.main.path(forResource: "plantfull", ofType: "gif") ?? "plantfull.gif"),
                isAnimating: self.$plantFullAnimating)
                .resizable()
                .playbackRate(1.0)
                .retryOnAppear(true)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 38))

        }
    }
}


struct MinePageContentView: View {
    var body: some View {
        Color(.blue).clipShape(RoundedRectangle(cornerRadius: 38))
    }
}

struct MainPageContentView: View {
    var isFull: Bool {
        get {
            return progress >= 100.0
        }
    }
    @Binding var tideAnimating: Bool
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
                        withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
                            self.progress += 30
                            if (self.progress >= 100.0) {
                                self.progress = 100.0
//                                self.growingAnimating = true
//                                self.tideAnimating = false
//                                print("We're setting self.growingAnimating to \(self.growingAnimating) and self.tideAnimating to \(self.tideAnimating)")
                            }
//                            print("Screen height would be: \(UIScreen.main.bounds.height)")
                        }
                    }) {
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
                                    .foregroundColor(Color("Lime"))
                                    .font(.custom("Source Han Sans Heavy", size: 16))
                                    .offset(y: 10)
                                // Don't create another timer here
                                Text("\(String(nowDate.day ?? 10))")
                                    .foregroundColor(Color("LightPurple"))
                                    .font(.custom("Source Han Sans Heavy", size: 40))

                                Text("日签")
                                    .foregroundColor(Color("LightPurple"))
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


                }.padding(.bottom)
                    .offset(y: -10)
                    .zIndex(1)

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
                        .animation(.easeInOut(duration: 2))

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
                        .animation(Animation.easeInOut(duration: 0.1).delay(1.0))



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
                    ZStack(alignment: .center) {
                        Text("解锁新牌阵")
                            .font(.custom("Source Han Sans Heavy", size: 12))
                            .foregroundColor(Color("LightPink"))
                            .background(ComplexCircleBackground(globalScale: 1.5, borderScale: 1.1, shapeShift: 1.0, isCircleBorder: true, innerColor: "MediumLime", outerColor: "LightPink", isFull: false))
                            .padding(.top, 30)
                            .padding(.bottom, 30)
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
        }
    }
}

extension AnyTransition {
    static var fly: AnyTransition { get {
        AnyTransition.modifier(active: FlyTransition(pct: 0), identity: FlyTransition(pct: 1))
    }
    }
}

struct FlyTransition: GeometryEffect {
    var pct: Double

    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        let rotationPercent = pct
        let a = CGFloat(Angle(degrees: 90 * (1 - rotationPercent)).radians)

        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1 / max(size.width, size.height)

        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0)

        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(pct * 2), y: CGFloat(pct * 2)))

        if pct <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}

let fromBottomToTop = AnyTransition
    .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))

struct ContentView: View {
    @State var weAreIn = Pages.mainPage
    @State var tideAnimating = true
    @State var plantFullAnimating = true
    @State var progress = 30.0


    var body: some View {
        ZStack(alignment: .bottom) {
            // Background color: a small shade of grey, filling the whole screen
            // Adding background color for different page
            // FIXME: should consider use more consistent color
            if (weAreIn == Pages.mainPage) {
                Color("LightGray")
            } else if (weAreIn == Pages.cardPage) {
                Color("DarkPurple")
            } else if (weAreIn == Pages.minePage) {
                Color(.blue)
            }
            // Background tidal wave as GIF, we use SDWebImageSwiftUI to load and use GIF

            if (weAreIn == Pages.mainPage) {
                MainPageContentView(tideAnimating: $tideAnimating, progress: $progress)
                    .transition(.fly)
                    .onDisappear() {
//                        print("MainPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = false
//                        self.plantFullAnimating = true
                    }.onAppear() {
//                        print("MainPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.cardPage) {
                CardPageContentView(plantFullAnimating: $plantFullAnimating)
                    .transition(.fly)
                    .onDisappear() {
//                        print("CardPageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = true
//                        self.plantFullAnimating = false
                    }.onAppear() {
//                        print("CardPageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            } else if (weAreIn == Pages.minePage) {
                MinePageContentView()
                    .transition(.fly)
                    .onDisappear() {
//                        print("MinePageContentView::onDisAppear, tideAnimating: \(self.tideAnimating)")
//                        self.tideAnimating = true
//                        self.plantFullAnimating = true
                    }.onAppear() {
//                        print("MinePageContentView::onAppear, tideAnimating: \(self.tideAnimating)")
                }
            }


            // The page selector, should remain if we're only navigating around different pages
            // And it should go when the scene is completely changed
            PageSelector(weAreIn: $weAreIn).padding(.bottom, 50)
        }.edgesIgnoringSafeArea(.all)
    }
}

// A small progress bar, cool, right?
struct LittleProgressBar: View {
    @Binding var value: Double
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(width: 100, height: 10)
                .opacity(0.5)
                .foregroundColor(Color(.white))
            Rectangle().frame(width: CGFloat(self.value), height: 10)
                .foregroundColor(Color("Lime"))
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
    var globalScale: CGFloat = 0.95
    var borderScale: CGFloat = 1.05
    var shapeShift: CGFloat = 1.03
    var isCircleBorder = false
    var innerColor = "Lime"
    var outerColor = "LightPurple"
    var shadeColor = "DarkLime"
    var isFull: Bool
    @State var isAtMaxScaleInner = false
    @State var isAtMaxScaleOuter = false
    @State var isToggled = false

    @State var toggleCount = 0

    var randID = Double.random(in: 0..<1)
    var shineAnimationInner = Animation
        .easeInOut(duration: 3.15)
        .repeatForever(autoreverses: true)
        .delay(Double.random(in: 0..<1))
    var shineAnimationOuter = Animation
        .easeInOut(duration: 2.95)
        .repeatForever(autoreverses: true)
        .delay(Double.random(in: 0..<1))
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if (self.isFull) {
                    Rectangle()
                        .foregroundColor(Color(self.shadeColor))
                        .frame(width: geometry.size.width * self.globalScale, height: geometry.size.width * self.globalScale * 2)
                        .rotationEffect(.degrees(45))
                        .offset(x: geometry.size.width * self.globalScale * sqrt(2) / 2, y: -geometry.size.width * self.globalScale * sqrt(2) / 2)
                }

                Ellipse()
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: [2]
                        )
                    )
                    .foregroundColor(Color(self.outerColor))
                    .frame(width: geometry.size.width * self.borderScale * self.globalScale * (self.isCircleBorder ? self.shapeShift : 1), height: geometry.size.width * self.globalScale * self.borderScale / (self.isCircleBorder ? self.shapeShift : 1))
                    .rotationEffect(self.isAtMaxScaleOuter ? .degrees(720) : .degrees(0))
                    .onAppear() {
                        withAnimation(self.shineAnimationOuter) {
                            // Should we just use isAtMaxScaleOuter?
                            // FIXME: myth...
                            // ? Why isn't this working?
                            // ? Why is on appear of this small background called multiple times?
                            // ? By who??
                            // ! I'm literally feeling cheated by this...
                            if (self.isCircleBorder) {
                                self.isAtMaxScaleOuter.toggle()
//                                self.isToggled.toggle()
//                                self.toggleCount += 1
//                                print("We're\(self.isCircleBorder ? "" : " not") in circle border and we've toggled self.isAtMaxScaleOuter from \(!self.isAtMaxScaleOuter) to \(self.isAtMaxScaleOuter) at \(Calendar.current.dateComponents([.second, .nanosecond], from: Date()).nanosecond ?? 0) and we're \(self.randID)")
//                                print("Current value of self.isToggled: \(self.isToggled) and we've toggled \(self.toggleCount) times, you should not see this message again on this object")
                            }
                        }

                }


                if (self.isCircleBorder) {
                    Ellipse()
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 2,
                                dash: [2]
                            )
                        )
                        .foregroundColor(Color(self.innerColor))
                        .frame(width: geometry.size.width * self.globalScale * self.shapeShift, height: geometry.size.width * self.globalScale / self.shapeShift)
                        .rotationEffect(self.isAtMaxScaleInner ? .degrees(360) : .degrees(0))
                        .onAppear() {
                            withAnimation(self.shineAnimationInner) {
                                self.isAtMaxScaleInner.toggle()
                            }
                    }
                } else {
                    Ellipse()
                        .fill(Color(self.innerColor))
                        .frame(width: geometry.size.width * self.globalScale, height: geometry.size.width * self.globalScale)
                }
            }
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
            withAnimation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 2)) {
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
