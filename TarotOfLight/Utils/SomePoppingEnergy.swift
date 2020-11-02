//
//  SomePoppingEnergy.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/11/2.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct PoppingEnergyPicker<Content: View>: View {
    var viewOffset: CGSize
    var minScale: CGFloat
    @State var isAtMaxScale: Bool = false
    var delay: Double
    var content: Content

    init(viewOffset: CGSize,
         minScale: CGFloat, delay: Double, @ViewBuilder content: @escaping () -> Content) {
        self.viewOffset = viewOffset
        self.minScale = minScale
        self.delay = delay
        self.content = content()
    }

    var body: some View {
        content
            .scaleEffect(isAtMaxScale ? 1 : minScale, anchor: .center)
            .position(x: 0, y: 0)
            .offset(viewOffset)
            .onAppear {
                withAnimation(
                    springAnimation
                        .delay(delay)
                ) {
                    isAtMaxScale.toggle()
                }
        }
    }
}

struct SomePoppingEnergy: View {
    var energies: [Double] = [13, 21, 34, 55]
    var onMe: Bool = true
    let viewSize: CGFloat = 50
    let minScale: CGFloat = 0.001
    let baseFontSize: CGFloat = 14
    let radiusScaleDown: CGFloat = 0.95

    var body: some View {
        GeometryReader {
            geo in
            ZStack {
                let width = geo.size.width
                let height = geo.size.height
                let radius = min(width, height)

                ForEach(0..<energies.count) {
                    index in
                    PoppingEnergyPicker(
                        viewOffset: randomPositionAroundCircle(radius: radius * 0.5),
                        //                        viewSize: viewSize,
                        minScale: minScale,
                        delay: .random(in: 0..<1)) {
                        EnergyAdderView(
                            energy: energies[index],
                            fontSize: baseFontSize,
                            shouldAppear: onMe
                        )

                    }.scaleEffect(radiusScaleDown)
                        .onAppear {
                            print("Getting the width and height and radius as: [\(width), \(height), \(radius)] and onMe: \(onMe)")
                    }
                }
            }
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
