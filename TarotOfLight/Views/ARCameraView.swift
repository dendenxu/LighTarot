//
//  ARCameraView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/14.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit
import Combine


struct ARCameraView: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var experienceStarted: Bool = false
    var body: some View {
        ZStack {
            ARCameraInnerView(navigator: $profile.viewNavigator)
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(springAnimation) {
                            profile.weAreInGlobal = .predictLight
                            profile.weAreIn = .category
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("LightGray").opacity(0.5))
                            Image("getback")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(8)
                        }
                            .frame(width: 30, height: 30)
                            .padding(.top, 60)
                            .padding(.leading, 30)
                            .scaleEffect(profile.viewNavigator.shouldScale ? 2 : 1)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct ARCameraInnerView: UIViewRepresentable {
    @Binding var navigator: ViewNavigation
    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero, navigator: $navigator)
        arView.addAnchor()
        arView.addCoaching()
        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) {
//        print("[AR] ExperienceStarted: \(experienceStarted)")
    }
}

class CustomARView: ARView, ARCoachingOverlayViewDelegate, ARSessionDelegate {
    @Binding var navigator: ViewNavigation

    var anchor = BasicPlant.BasicPlantScene()
    var collisions: [Cancellable] = []

    // MARK: Custom profile
    init(frame frameRect: CGRect, navigator: Binding<ViewNavigation>) {
        self._navigator = navigator
        super.init(frame: frameRect)
    }

    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCollisions() {
        let beginSub = self.scene.subscribe(to: CollisionEvents.Began.self, on: anchor.goldenBox) {
            event in

            print("\(event.entityA) collided with \(event.entityB)")
        }

        let endSub = self.scene.subscribe(to: CollisionEvents.Ended.self, on: anchor.goldenBox) {
            event in
            self.navigator.shouldScale = true
            print("\(event.entityA)'s collision with \(event.entityB) ended")
        }
        collisions.append(beginSub)
        collisions.append(endSub)
        print("[CAMERA] Now subscriptions are added")
    }

    func addAnchor() {
        do {
            try anchor = BasicPlant.loadBasicPlantScene()
            print("Information about anchor: \(anchor)")
            for child in anchor.children {
                child.transform.rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))
                print("Getting child: \(child)")
            }
            self.environment.sceneUnderstanding.options = [.occlusion]
            self.scene.anchors.append(anchor)
            print("[ARCoaching] The plant is successfully loaded to the anchor, \(self.scene.anchors.count) anchors in total")
        } catch {
            print("Ah... Something went wrong, I think you're getting a black screen now.")
        }
    }

    func addCoaching() {
        // Create a ARCoachingOverlayView object
        let coachingOverlay = ARCoachingOverlayView()
        // Make sure it rescales if the device orientation changes
        coachingOverlay.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
        ]
        // Set the Augmented Reality goal
        coachingOverlay.goal = .horizontalPlane
        // Set the ARSession
        coachingOverlay.session = self.session
        // Set the delegate for any callbacks
        coachingOverlay.delegate = self

        self.session.delegate = self

        print("[AR] Adding coaching")
        self.addSubview(coachingOverlay)
    }


    func addObjects() {
        print("[ARCoaching] Getting \(self.scene.anchors.count) anchors")
        anchor.generateCollisionShapes(recursive: true)

        if let evilEye = anchor.evilEye as? Entity & HasCollision {
            self.installGestures(.all, for: evilEye)
            print("[AR] evilEye has collision")
        } else { print("[ARBAD] evilEye doesn't have collision, check whether physics is enabled in reality kit") }


        if let theCard = anchor.theCard as? Entity & HasCollision {
            self.installGestures(.all, for: theCard)
            print("[AR] theCard has collision")
        } else { print("[ARBAD] theCard doesn't have collision, check whether physics is enabled in reality kit") }


        if let theBox = anchor.goldenBox as? Entity & HasCollision {
            self.installGestures(.all, for: theBox)
            print("[AR] theBox has collision")
        } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }

        if let theBox = anchor.goldenBoxLeft as? Entity & HasCollision {
            self.installGestures(.all, for: theBox)
            print("[AR] theBox has collision")
        } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }

        if let theBox = anchor.goldenBoxMiddle as? Entity & HasCollision {
            self.installGestures(.all, for: theBox)
            print("[AR] theBox has collision")
        } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }

        if let theBox = anchor.goldenBoxRight as? Entity & HasCollision {
            self.installGestures(.all, for: theBox)
            print("[AR] theBox has collision")
        } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }


        // MARK: desparate

//        if let customBox = anchor.goldenBox?.clone(recursive: true) as? CustomBox, let oldBox = anchor.goldenBox {
//            anchor.removeChild(oldBox)
//            anchor.addChild(customBox)
//            print("[AR] Adding new custom box to the scene, check it's position")
//        } else { print("[ARBAD] cannot assign to CustomBox") }



        for card in anchor.cardEntities {
            if let card = card as? Entity & HasCollision {
                self.installGestures(.all, for: card)
                print("[AR] the card has collistion")
            } else { print("[ARBAD] A Card doesn't have collision, check whether physics is enabled in reality kit") }
        }
    }

    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("[COACHING] Deactivated")
        addObjects()
        addCollisions()
    }

}

//class CustomBox: Entity, HasCollision {
//    var sub: [Cancellable] = []
//
//    init(entity: Entity) {
//        print("[CustomBox] Calling init")
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}
