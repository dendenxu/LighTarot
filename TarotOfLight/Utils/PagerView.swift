//
//  PagerView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/28.
//  Copyright © 2020 xz. All rights reserved.
//
import SwiftUI
struct PagerView<Content: View>: View {
    let content: Content
    let pageCount: Int
    let hasPageDot: Bool
    @Binding var currentIndex: Int
    @Binding var percentages: [CGFloat] // left, right middle
    @State var translation: CGFloat = 0
    @EnvironmentObject var profile: LighTarotModel
    init(accentColor: Color = Color.white.opacity(0.9), overlookColor: Color = Color.gray.opacity(0.7), backgroundColor: Color = Color.white.opacity(0.3), hasPageDot: Bool = true, pageCount: Int = 3, currentIndex: Binding<Int>, percentages: Binding<[CGFloat]>, @ViewBuilder content: () -> Content) {
        self.accentColor = accentColor
        self.overlookColor = overlookColor
        self.backgroundColor = backgroundColor
        self.hasPageDot = hasPageDot
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self._percentages = percentages
        self.content = content()
    }

    private func onEndedAction(index: Int, width: CGFloat) {
        let oldValue = currentIndex
        currentIndex = index
        isChanging = false
        profile.pagerSuccess(count: abs(currentIndex - oldValue))
        print("Current translation: \(translation), currentIndex: \(currentIndex)")
        withAnimation(fastSpringAnimation) {
            translation = -CGFloat(currentIndex) * width
            // DUP: duplicated code fragment, consider optimization
            for index in 0..<pageCount {
                percentages[index] = (translation + CGFloat(index) * width) / width
            }
        }
        print("Paging gesture ended! Percentages are: [\(percentages)]")
    }

    private func delay() {
        // Delay of 3 seconds
        counter += 1
        print("Waiting a while... counter: \(counter)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            counter -= 1
            if selecting && (counter == 0) {
                withAnimation(springAnimation) {
                    selecting = false
                }
                print("Done!")
            } else {
                print("Not selected")
            }
        }
    }

    func tapGesture(index: Int = 0, width: CGFloat = .ScreenWidth) {
        print("SMALL BUTTON PRESSED! of index \(index)")
        onEndedAction(index: index, width: width)
        delay()
        if !selecting {
            withAnimation(springAnimation) {
                selecting = true
            }
        }
    }

    @State var isChanging = false
    @State var selecting = false
    @State var counter: Int = 0
    let spacing: CGFloat = 3
    let accentColor: Color
    let overlookColor: Color
    let backgroundColor: Color
    func dotColor(index: Int) -> Color { return index == currentIndex ? accentColor : overlookColor }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let width = geometry.size.width
                let PagerDragGesture =
                    DragGesture(
                        minimumDistance: 20,
                        coordinateSpace: .local
                    )
                    .onEnded { value in
                        let offset = value.predictedEndTranslation.width / width
                        let newIndex = (CGFloat(currentIndex) - offset).rounded()
                        let index = min(max(Int(newIndex), 0), pageCount - 1)
                        onEndedAction(index: index, width: width)
                    }
                    .onChanged { value in
                        print("Paging gesture changing...")
                        let translationW = value.translation.width - CGFloat(currentIndex) * width
                        let translationH = value.translation.height
                        if isChanging || translationH < 10 {
                            print("Are we currently changing: \(isChanging)")
                            isChanging = true
                            withAnimation(fastSpringAnimation) {
                                translation = translationW
                                for index in 0..<pageCount {
                                    percentages[index] = (translationW + CGFloat(index) * width) / width
                                }
                            }
                        } else {
                            isChanging = false // This bool is magically making things work
                        }
                }

                HStack(spacing: 0) {
                    content
                        .frame(width: width)
                }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: translation)
                    .gesture(PagerDragGesture)
                VStack {
                    Spacer()
                    ZStack {
                        // This is ridiculous... Adding a rectangle frame around it will make the gesture recognizable?

                        HStack(spacing: 0) {
                            ForEach(0..<pageCount) { index in
                                Button(action: {
                                    tapGesture(index: index, width: width)
                                }) {
                                    ZStack {
                                        Ellipse()
                                            .frame(width: selecting ? 22.5 : 15, height: selecting ? 80 : 40)
                                            .hidden()
                                            .overlay(Circle().foregroundColor(dotColor(index: index)).frame(width: 9, height: 9))
                                            .padding(.leading, index == 0 ? (selecting ? 12.5 : 5) : 0)
                                            .padding(.trailing, index == pageCount - 1 ? (selecting ? 12.5 : 5) : 0)
                                    }
                                }
                            }
                        }
                            .background(
                                GeometryReader {
                                    geo in
                                    VStack {
                                        Capsule().foregroundColor(backgroundColor)
                                            .frame(width: geo.size.width, height: geo.size.height / 1.75)
                                            .offset(y: geo.size.height / 2 - geo.size.height / 1.75 / 2)
                                    }
                                }
//                                Capsule().foregroundColor(backgroundColor)
                            )
                    }.padding(.bottom, selecting ? 50 : 60)
                }
            }
        }
    }
}
