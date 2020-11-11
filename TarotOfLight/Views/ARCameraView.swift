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

#if targetEnvironment(simulator)
    struct ARCameraView: View {
        var body: some View {
            Text("Hello.")
        }
    }
#else
    struct ARCameraView: View {
        @EnvironmentObject var profile: LighTarotModel
        @State var animationFinished = false
        var body: some View {
            ZStack {
                ARCameraInnerView(navigator: $profile.navigator)
//                .frame(width: .ScreenWidth, height: .ScreenHeight)

                if !profile.navigator.anchorAdded {
                    Color.black.opacity(0.8) // Black mask if not currently in an ARScene
                }

                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(springAnimation) {
                                profile.weAreInGlobal = .predictLight
                                profile.weAreIn = .category
                                profile.navigator.shouldStartExperience = false
                                profile.navigator.anchorAdded = false
                                profile.navigator.cardsShuffled = false
                                profile.navigator.shouldScale = false
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
                                .scaleEffect(profile.navigator.shouldScale ? 2 : 1)
                                .onReceive(NotificationCenter.default.publisher(for: NSNotification.DebugNotification)) {
                                    obj in
                                    print("[DEBUG] So did we really changed: \(profile.navigator.shouldScale)")
                            }
                        }
                        Spacer()
                    }
                    Spacer()

                    if !profile.navigator.shouldStartExperience {
                        Button(action: {
                            withAnimation(springAnimation) {
                                profile.navigator.shouldStartExperience = true
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

                // Centered text
                if !profile.navigator.anchorAdded && profile.navigator.shouldStartExperience {
                    ShinyText(text: "正在寻找有光的平面……", font: .DefaultChineseFont, size: 20, textColor: .white, shadowColor: Color.black.opacity(0))
                        .transition(scaleTransition)
                } else if profile.navigator.anchorAdded && !profile.navigator.cardsShuffled {
                    // On appear, move to the lower right corner
                    // to not disturb the user
                    ShinyText(text: "触摸塔罗牌，开始洗牌", font: .DefaultChineseFont, size: 20, textColor: .white, shadowColor: Color.black.opacity(0))
                        .transition(scaleTransition)
//                        .offset(x: animationFinished ?
//                                    .ScreenWidth / 2 - 100
//                        0
//                            : 0, y: animationFinished ? -.ScreenHeight / 2 - 100: 0)
                    .onAppear {
                        withAnimation(springAnimation) {
                            animationFinished = true
                        }

                    }
                } else if profile.navigator.cardsShuffled {
                    ShinyText(text: "凝神静气，选择三张塔罗牌", font: .DefaultChineseFont, size: 20, textColor: .white, shadowColor: Color.black.opacity(0))
                        .transition(scaleTransition)
//                        .offset(x: animationFinished ?
//                                    .ScreenWidth / 2 - 100
//                        0
//                            : 0, y: animationFinished ? -.ScreenHeight / 2 - 100: 0)
                    .onAppear {
                        animationFinished = false
                        withAnimation(springAnimation) {
                            animationFinished = true
                        }
                    }
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
        var notifications: [Cancellable] = []
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


            // MARK: Is it OK to generate ModelEntity?
            let emptyMesh = MeshResource.generateBox(size: 0)
            let boxes = [anchor.goldenBoxLeft, anchor.goldenBoxMiddle, anchor.goldenBoxRight]
            for box in boxes {
                if let theBox = box as? Entity & HasCollision {
                    if let theModelBox = theBox.children.first as? ModelEntity {
                        print("[AR] theModelBox has collision, can be viewed as ModelEntity")
                        // The boxes should not be able to be draged anymore...
                        //                    self.installGestures(.all, for: theBox)
                        // Instead we'll be wanting to make them invisible by setting the mesh to 0 depth cube
                        print("[MODEL] Has model: \(String(describing: theModelBox.model))")
                        print("[MODEL] Has components: \(String(describing: theModelBox.components))")

                        // There might just exist a better way to do it
                        if theModelBox.model == nil {
                            print("[MODELWARN] No model in theBox, check again pls")
                        } else {
                            theModelBox.model?.mesh = emptyMesh
                        }
                    } else {
                        print("[ARBAD] GoldenBox doesn't have collision or cannot be viewed as model entity, check whether physics is enabled in reality kit")
                        print("Then what on earth is it?: \(String(describing: box))")

                    }

                    // MARK: Fingers crossed
                    let beginSub = scene.subscribe(to: CollisionEvents.Began.self, on: theBox) {
                        event in
                        print("[BOX] The box: \(event.entityA.name) has collide with \(event.entityB.name)")
                        print("[BOX] So what's event.entityB again? \(event.entityB)")
                        if event.entityB.name == "CardModel" {
                            print("Entity")
                            // On collision, we scale the chosen object
                            // MARK: But only the cards for now!
//                            event.entityB.scale *= 1.2
                            let theCard = event.entityB
                            let scaleTransform = Transform(scale: SIMD3<Float>.one * 1.5, rotation: simd_quatf(angle: 0, axis: SIMD3<Float>.zero), translation: SIMD3<Float>.zero)
                            theCard.move(to: scaleTransform, relativeTo: theCard, duration: 0.2, timingFunction: .easeInOut)
                        }
                    }

                    let endSub = scene.subscribe(to: CollisionEvents.Ended.self, on: theBox) {
                        event in
                        print("[BOX] The box: \(event.entityA.name)'s collision with \(event.entityB.name) ended")

                        if event.entityB.name == "CardModel" {
                            // On collision, we scale the chosen object
                            // MARK: But only the cards for now!
                            let theCard = event.entityB
                            let scaleTransform = Transform(scale: SIMD3<Float>.one / 1.5, rotation: simd_quatf(angle: 0, axis: SIMD3<Float>.zero), translation: SIMD3<Float>.zero)
                            theCard.move(to: scaleTransform, relativeTo: theCard, duration: 0.2, timingFunction: .easeInOut)
                        }
                    }

                    // Save the subscription to an array
                    collisions.append(beginSub)
                    collisions.append(endSub)

                }
            }

//            if let theBox = anchor.goldenBoxLeft as? Entity & HasCollision {
//                self.installGestures(.all, for: theBox)
//                print("[AR] theBox has collision")
//            } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }
//
//            if let theBox = anchor.goldenBoxMiddle as? Entity & HasCollision {
//                self.installGestures(.all, for: theBox)
//                print("[AR] theBox has collision")
//            } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }
//
//            if let theBox = anchor.goldenBoxRight as? Entity & HasCollision {
//                self.installGestures(.all, for: theBox)
//                print("[AR] theBox has collision")
//            } else { print("[ARBAD] GoldenBox doesn't have collision, check whether physics is enabled in reality kit") }

            for card in anchor.cardEntities {
                if let card = card as? Entity & HasCollision {
                    // MARK: I'm literally.... Errrrr....
                    if let cardModel = card.children.first?.children.first?.children.first?.children.first?.children.first as? ModelEntity {

                        // MARK: Collision seems only to be able to work with entityB being some ModelEntity inside the original one
                        print("[NAME] Changing card name \(cardModel.name) to cardModel")
                        cardModel.name = "CardModel"
                    }
                    print("So the card is like: \(card)")
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


            anchor.actions.cardOperation1.onAction = handleShuffleEnd
            print("[NOTIFICATION] Notification handler for \(anchor.actions.cardOperation1.identifier) registered as \(String(describing: handleShuffleEnd))")

        }

        func handleShuffleEnd(entity: Entity?) {
            print("[NOTIFICATION] Notification from reality kit received")
            withAnimation(springAnimation) {
                navigator.cardsShuffled = true
            }
        }

        public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            print("[COACHING] Deactivated")
            addCollisions()
        }

    }
#endif
