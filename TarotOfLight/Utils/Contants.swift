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
//    public static let DefaultChineseFont = "DFPHeiW12-GB"
    public static let DefaultChineseFont = String.SourceHanSansHeavy
    public static let DFPHeiW12 = "DFPHeiW12-GB"
    public static let SourceHanSansHeavy = "Source Han Sans Heavy"
    public static let SourceHanSansMedium = "Source Han Sans Medium"
    public static let SourceHanSansLight = String.SourceHanSansMedium
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
    static let DragCancel = NSNotification.Name.init("LongPressCancel")
    static let PagerTapped = NSNotification.Name.init("PaggerTapped")
}

func randomPositionInCircle(radius: CGFloat) -> CGSize {
    let randRadius = CGFloat.random(in: 0..<radius)
    let randAngle = CGFloat.random(in: 0..<2 * CGFloat.pi)
    let x = randRadius * cos(randAngle)
    let y = randRadius * sin(randAngle)
    return CGSize(width: x + radius, height: y + radius)
}

func randomPositionAroundCircle(radius: CGFloat) -> CGSize {
    print("Getting Radius: \(radius)")
    let randAngle = CGFloat.random(in: 0..<2 * CGFloat.pi)
    let x = radius * cos(randAngle)
    let y = radius * sin(randAngle)

    return CGSize(width: x + radius, height: y + radius)
}

func randomPositionInDoubleRectangle(size: CGSize) -> CGSize {
//    print("We're randomly generating size for bounds: \(size.width), \(size.height)")
    return CGSize(width: 2 * size.width * CGFloat.random(in: 0..<1) - size.width, height: 2 * size.height * CGFloat.random(in: 0..<1) - size.height)
}

func distance(s1: CGSize, s2: CGSize) -> CGFloat {
    return sqrt((s1.width - s2.width) * (s1.width - s2.width) + (s1.height - s2.height) * (s1.height - s2.height))
}

func adjustSize(toAdjust: CGSize, scale: CGFloat = 1.0, offset: CGFloat = 30) -> CGSize {
    return toAdjust * scale + CGSize(width: toAdjust.width / toAdjust.distance * offset, height: toAdjust.height / toAdjust.distance * offset)
//    return toAdjust
}

extension CGSize {
    init(p: CGPoint) {
        self = CGSize(width: p.x, height: p.y)
    }
    static func + (s1: CGSize, s2: CGSize) -> CGSize {
        return CGSize(width: s1.width + s2.width, height: s1.height + s2.height)
    }
    static func * (s: CGSize, scale: CGFloat) -> CGSize {
        return CGSize(width: s.width * scale, height: s.height * scale)
    }
    static func - (s1: CGSize, s2: CGSize) -> CGSize {
        return CGSize(width: s1.width - s2.width, height: s1.height - s2.height)
    }

    var distance: CGFloat {
        sqrt(self.width * self.width + self.height * self.height)
    }
}

extension CGPoint {
    var distance: CGFloat {
        sqrt(self.x * self.x + self.y * self.y)
    }
}
