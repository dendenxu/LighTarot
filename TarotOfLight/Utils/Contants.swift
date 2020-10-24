//
//  Contants.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/9/27.
//  Copyright © 2020 xz. All rights reserved.
//
import Combine
import SwiftUI
extension CGFloat {
    public static let ScreenCornerRadius: CGFloat = 38.0
}

extension String {
    public static let DefaultChineseFont = "DFPHeiW12-GB"
    public static let SourceHanSansHeavy = "Source Han Sans Heavy"
    public static let SourceHanSansMedium = "Source Han Sans Medium"
    public static let SourceHanSansLight = "Source Han Sans Light"
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

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
