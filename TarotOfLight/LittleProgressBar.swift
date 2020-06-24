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
