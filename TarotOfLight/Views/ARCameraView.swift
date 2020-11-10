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
//                .frame(width: .ScreenWidth, height: .ScreenHeight)
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(springAnimation) {
                            profile.weAreInGlobal = .predictLight
                            profile.weAreIn = .category
                            profile.viewNavigator.shouldStartExperience = false
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
                            .onReceive(NotificationCenter.default.publisher(for: NSNotification.DebugNotification)) {
                                obj in
                                print("[DEBUG] So did we really changed: \(profile.viewNavigator.shouldScale)")
                        }
                    }
                    Spacer()
                }
                Spacer()

                if !profile.viewNavigator.shouldStartExperience {
                    Button(action: {
                        withAnimation(springAnimation) {
                            profile.viewNavigator.shouldStartExperience = true
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundColor(Color("LightGray").opacity(0.5))
                            ShinyText(text: "点击开始\n卜光体验", font: .DefaultChineseFont, size: 14, textColor: .white, shadowColor: Color.black.opacity(0))
                        }
                            .frame(width: 90, height: 65)
                            .padding(.bottom, 100)
                    }
                }

            }



            if !profile.viewNavigator.anchorAdded && profile.viewNavigator.shouldStartExperience {
                ShinyText(text: "正在寻找有光的平面……", font: .DefaultChineseFont, size: 20, textColor: .white, shadowColor: Color.black.opacity(0))
                    .transition(scaleTransition)
            }
        }
    }
}

struct ARCameraInnerView: UIViewRepresentable {
    @Binding var navigator: ViewNavigation

    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero, navigator: $navigator)
        return arView
    }

    func updateUIView(_ arView: CustomARView, context: Context) {
        if navigator.shouldStartExperience && !arView.started {
            arView.addAnchor()
//            arView.addCoaching()
            arView.addCollisions()
            arView.started = true
            print("[AR] ExperienceStarted: \(arView.started)")
        }
    }
}

class CustomARView: ARView, ARCoachingOverlayViewDelegate, ARSessionDelegate {
    @Binding var navigator: ViewNavigation

    var anchor = BasicPlant.BasicPlantScene()
    var collisions: [Cancellable] = []
    var started: Bool = false
    var anchored: Bool = false

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

//    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
////        print("[NAME] ANCHORS are added: \(anchors)")
////        if let anchor = anchors.first {
////            print("[NAME] The anchor \(String(describing: anchor.name)) is successfully added")
////        }
//        // FIXME: Bad practice
//        print("[NAME] We want: \(String(describing: anchor.anchorIdentifier))")
//        for arAnchor in anchors {
//            print("[NAME] Getting anchor: \(arAnchor.identifier)")
//
//            if arAnchor.identifier == anchor.anchorIdentifier ?? UUID() {
//                withAnimation(springAnimation) {
//                    navigator.anchorAdded = true
//                }
//                print("[NAME] HIT! Scene is loaded and anchored to anchor: \(arAnchor.identifier)")
//            }
//        }
//    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if anchor.isAnchored {
            if !anchored {
                anchored = true
                print("[ANCHOR] now anchored")
                withAnimation(springAnimation) {
                    navigator.anchorAdded = true
                }
            }
        } else {
            anchored = false
        }
    }

    

    func addAnchor() {
        do {
            try anchor = BasicPlant.loadBasicPlantScene()

            print("[NAME] anchor's ID: \(String(describing: anchor.anchorIdentifier))")
            print("Information about anchor: \(anchor)")
            for child in anchor.children {
                child.transform.rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))
                print("Getting child: \(child)")
            }
            self.environment.sceneUnderstanding.options = [.occlusion]

            self.scene.anchors.append(anchor)

            self.session.delegate = self
            print("[ARCoaching] The plant is successfully loaded to the anchor, \(self.scene.anchors.count) anchors in total")
        } catch {
            print("Ah... Something went wrong, I think you're getting a black screen now.")
        }
    }

    func addCoaching() {
        // Create a ARCoachingOverlayView object
        let coachingOverlay = ARCoachingOverlayView(frame: .zero)
//        // Make sure it rescales if the device orientation changes
//        coachingOverlay.autoresizingMask = [
//                .flexibleWidth, .flexibleHeight
//        ]
        // Set the Augmented Reality goal
        coachingOverlay.goal = .horizontalPlane
        // Set the ARSession
        coachingOverlay.session = self.session
        // Set the delegate for any callbacks
        coachingOverlay.delegate = self

        print("[AR] Adding coaching")
        self.addSubview(coachingOverlay)
    }


    func addCollisions() {
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

        for card in anchor.cardEntities {
            if let card = card as? Entity & HasCollision {
                self.installGestures(.all, for: card)
                print("[AR] the card has collistion")
            } else { print("[ARBAD] A Card doesn't have collision, check whether physics is enabled in reality kit") }
        }

        let beginSub = self.scene.subscribe(to: CollisionEvents.Began.self, on: anchor.goldenBox) {
            event in
            withAnimation(springAnimation) {
                self.navigator.shouldScale.toggle()
            }
            print("\(event.entityA.name) collided with \(event.entityB.name)")
        }

        let endSub = self.scene.subscribe(to: CollisionEvents.Ended.self, on: anchor.goldenBox) {
            event in
            withAnimation(springAnimation) {
                self.navigator.shouldScale.toggle()
            }

            print("\(event.entityA.name)'s collision with \(event.entityB.name) ended")
        }
        collisions.append(beginSub)
        collisions.append(endSub)
        print("[CAMERA] Now subscriptions are added")
    }

    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("[COACHING] Deactivated")
        addCollisions()
    }

}
