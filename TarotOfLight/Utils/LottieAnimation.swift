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
        // Leaving this function empty seems to speed up some SwiftUI animation
        // MARK: Guess the optimation of SwiftUI is taking place here
//        print("View got updated... If something is wrong, the animation should be stopped...")
    }

}
