//
//  LittleProgressBar.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

// A small progress bar, cool, right?
struct LittleProgressBar: View {
    var value: Double
    var fontSize: CGFloat {
        if value > 30 { return 12 }
        else { return CGFloat((30 - value) / 30 * 12) }
    }
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                let width = geo.size.width
                Rectangle().frame(width: width)
                    .opacity(0.5)
                    .foregroundColor(Color(.white))
                ZStack {
                    Rectangle().frame(width: CGFloat(value) / 100 * width)
                        .foregroundColor(Color("Lime"))
                    Text(String(format: "%.0f", value) + ((value > 30) ? "%" : ""))
                        .foregroundColor(.white)
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                }
            }
                .cornerRadius(45.0)
                .shadow(radius: 5)
                .onAppear {
                    print("Getting width: \(geo.size.width)")
            }
        }
    }
}
