//
//  Contants.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/9/27.
//  Copyright © 2020 xz. All rights reserved.
//
import Combine
import SwiftUI
import SDWebImageSwiftUI
extension CGFloat {
    public static let ScreenCornerRadius: CGFloat = 38.0
    public static let ScreenWidth = UIScreen.main.bounds.width
    public static let ScreenHeight = UIScreen.main.bounds.height
}

extension String {
    public static let DefaultChineseFont = "DFPHeiW12-GB"
    public static let SourceHanSansHeavy = "Source Han Sans Heavy"
    public static let SourceHanSansMedium = "Source Han Sans Medium"
    public static let SourceHanSansLight = "Source Han Sans Light"
}

extension Image {
    public static func `default`(_ name: String) -> some View {
        return Image(name)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
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

extension UIImage {
    func toBase64() -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    static func fromBase64(base64: String) -> UIImage {
        return UIImage(data: Data.init(base64Encoded: base64) ?? Data()) ?? UIImage()
    }
}

extension WebImage {
    public static func `default`(url: URL, isAnimating: Binding<Bool>) -> some View {
        return WebImage(url: url, isAnimating: isAnimating)
            .resizable()
            .playbackRate(1.0)
            .retryOnAppear(true)
            .scaledToFill()
    }
}

extension NSNotification {
    static let LongPressCancel = NSNotification.Name.init("LongPressCancel")
}
