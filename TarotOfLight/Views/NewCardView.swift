//
//  NewCardView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/11/2.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

struct NewCardView: View {
    var globalScale: CGFloat = 0.95
    var shapeShift: CGFloat = 1.03
    let isFull: Bool = false
    let plantRadius: CGFloat = 350 / 414 * .ScreenWidth
    var body: some View {
        ZStack {
            ComplexCircleBackground(globalScale: globalScale, shapeShift: shapeShift, innerColor: "LightGray", isFull: isFull).scaledToFit()
        }.frame(width: plantRadius, height: plantRadius)

    }
}

struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardView()
            .previewDevice("iPhone 11")
    }
}
