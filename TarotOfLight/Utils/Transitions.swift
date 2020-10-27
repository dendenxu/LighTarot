//
//  Transitions.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/6/24.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var fly: AnyTransition { get {
        AnyTransition.modifier(active: FlyTransition(pct: 0), identity: FlyTransition(pct: 1))
    }
    }
}

struct FlyTransition: GeometryEffect {
    var pct: Double

    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        let rotationPercent = pct
        let a = CGFloat(Angle(degrees: 90 * (1 - rotationPercent)).radians)

        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1 / max(size.width, size.height)

        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0)

        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(pct * 2), y: CGFloat(pct * 2)))

        if pct <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}

let fromBottomToTop = AnyTransition
    .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))

let springAnimation = Animation.spring(response: 0.5, dampingFraction: 1, blendDuration: 2)
let fastSpringAnimation = Animation.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 1)
let fasterSpringAnimation = Animation.spring(response: 0.5, dampingFraction: 1, blendDuration: 1)
