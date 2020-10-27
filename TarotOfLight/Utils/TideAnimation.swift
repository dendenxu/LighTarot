//
//  TideAnimation.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/23.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import Lottie
struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode

    private var animationView = AnimationView()

    init(name: String = "tide", loopMode: LottieLoopMode = .loop) {
        self.name = name
        self.loopMode = loopMode
    }

    func completion(block: Bool) {
        print("Animation is completed, current LoopMode is set to \(loopMode), and are we OK?: \(block), current animationView: \(animationView.isAnimationPlaying) \(animationView.loopMode)")
        print("Are we doing a recursion? If this line is presented, we are not.")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LottieView

        init(_ animationView: LottieView) {
            self.parent = animationView
            super.init()
        }
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play(completion: completion)

        return view
    }


    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        print("View got updated... If something is wrong, the animation should be stopped...")
    }

}

struct SpiroSquare: Shape {
    func path(in rect: CGRect) -> Path {

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.534, y: 0.5816))
        path.addCurve(to: CGPoint(x: 0.1877, y: 0.088), controlPoint1: CGPoint(x: 0.534, y: 0.5816), controlPoint2: CGPoint(x: 0.2529, y: 0.4205))
        path.addCurve(to: CGPoint(x: 0.9728, y: 0.8259), controlPoint1: CGPoint(x: 0.4922, y: 0.4949), controlPoint2: CGPoint(x: 1.0968, y: 0.4148))
        path.addCurve(to: CGPoint(x: 0.0397, y: 0.5431), controlPoint1: CGPoint(x: 0.7118, y: 0.5248), controlPoint2: CGPoint(x: 0.3329, y: 0.7442))
        path.addCurve(to: CGPoint(x: 0.6211, y: 0.0279), controlPoint1: CGPoint(x: 0.508, y: 1.1956), controlPoint2: CGPoint(x: 1.3042, y: 0.5345))
        path.addCurve(to: CGPoint(x: 0.6904, y: 0.3615), controlPoint1: CGPoint(x: 0.7282, y: 0.2481), controlPoint2: CGPoint(x: 0.6904, y: 0.3615))

        let shape = Path(path.cgPath)

        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let multiplier = min(rect.width, rect.height)

        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)

        // Apply that scale and send back the result.
        return shape.applying(transform)
    }
}
