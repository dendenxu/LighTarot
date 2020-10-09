//
//  InterpreterView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/9.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct OuterInterpreterView: View {
    @State var plantFullAnimating: Bool = true
    @State var placerHolderDelay: Bool = false // STUB: should communicate with backend instead
    var body: some View {
        ZStack {
            if !placerHolderDelay {
                Button(action: {
                    if !placerHolderDelay {
                        withAnimation(springAnimation) {
                            placerHolderDelay = true
                        }
                        print("Animation done, should show interpretation")
                    } else {
                        print("Not the first time called")
                    }
                }) {
                    WebImage(
                        url: URL(fileURLWithPath: Bundle.main.path(forResource: "plantfull", ofType: "gif") ?? "plantfull.gif"),
                        isAnimating: self.$plantFullAnimating)
                        .resizable()
                        .playbackRate(1.0)
                        .retryOnAppear(true)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: .ScreenCornerRadius))
                        .onAppear(perform: delay)
                }
            } else {
                InterpreterView()
            }


        }
    }
    private func delay() {
        // Delay of 3 seconds
        print("Playing the animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if !placerHolderDelay {
                withAnimation(springAnimation) {
                    placerHolderDelay = true
                }
                print("Animation done, should show interpretation")
            } else {
                print("Not the first time called")
            }

        }
    }
}


struct CheckedLazyVStack<Content: View>: View {
    var alignment: HorizontalAlignment
    var spacing: CGFloat
    var content: Content
    init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 10, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        } else {
            // Fallback on earlier versions
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

struct InterpreterView: View {
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                ShinyText(text: "过去的状态", size: 20, textColor: Color("MediumLime"), shadowColor: Color("MediumLime"))
                Spacer()
                HStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Image("share")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .shadow(color: Color("Lime"), radius: 3)
                    Image("download")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .shadow(color: Color("Lime"), radius: 3)
                }
            }
                .padding(.top, 60)
                .padding(.horizontal, 30)


            ScrollView {
                CheckedLazyVStack {
                    Image("theHierophant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270)
                        .padding(.top, 10)
                        .zIndex(1)

                    ShinyText(text: "SHOULD SHOW ACTUAL CARD INTERPRETATION VIEW HERE", font: .DefaultChineseFont, size: 20)
                        .background(
                            ShinyBackground(
                                nStroke: 20,
                                nFill: 20,
                                size: CGSize(
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height
                                )
                            )
                        )
                        .padding(20)
                        .zIndex(0.5)

                    Spacer()
                }
            }
        }
    }
}
