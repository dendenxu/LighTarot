//
//  ShinyWord.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

// FIXME: A lot of bad naming here, need rescue for further development
struct ShinyText: View {
    var font: String
    var size: CGFloat
    var maxScale: CGFloat
    var textColor: Color
    var shadowColor: Color
    var shadowRadius: CGFloat
    var isScaling = false
    var textfield: textField
    @State private var isAtMaxScale = false

    // Using custom initializer so as to give teh editableText a binding default value
    init(text: String = "解锁新牌阵", font: String = .SourceHanSansHeavy, size: CGFloat = 12.0, maxScale: CGFloat = 1.5, textColor: Color = Color("LightPink"), shadowColor: Color = .white, shadowRadius: CGFloat = 3.0, isScaling: Bool = false, editable: Bool = false, editableText: Binding<String> = .constant("Hello"), placeholder: String = "Placeholder") {
        textfield = textField(editableText: editableText, text: text, editable: editable, placeholder: placeholder)
        self.font = font
        self.size = size
        self.maxScale = maxScale
        self.textColor = textColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.isScaling = isScaling
    }


    // We created this structure to avoid having to specify properties multiple times
    struct textField: View {
        @Binding var editableText: String
        var text: String
        var editable = false
        @State var placeholder = "Placeholder"
        var body: some View {
            if editable {
                TextField(placeholder, text: $editableText, onEditingChanged: { editing in
                    print("Editing TextField Change: \($editableText), editing: \(editing)")
                    if editing == false { editableText = placeholder }
                }, onCommit: { placeholder = editableText })
                    .multilineTextAlignment(.center)
            } else {
                Text(text)
            }
        }
    }

    var body: some View {
        // BUG: If we use geometry reader here, the UI at the second page will be broken
        textfield
            .font(.custom(font, size: size))
            .foregroundColor(textColor)
            .shadow(color: shadowColor.opacity(isAtMaxScale ? 0.8 : 0.5), radius: shadowRadius * (isAtMaxScale ? 1 / maxScale : maxScale))
            .onAppear() {
                withAnimation(shineAnimationOuter) {
                    isAtMaxScale.toggle()
                }
        }
    }
}
