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


struct ARCameraView: View {
    @EnvironmentObject var profile: LighTarotModel
    @State var experienceStarted: Bool = false
    var body: some View {
        ZStack {
            ARCameraInnerView(experienceStarted: $experienceStarted)
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
                    }
                    Spacer()
                }
                Spacer()
            }
            
            
        }
    }
}

struct ARCameraInnerView: UIViewRepresentable {
    @Binding var experienceStarted: Bool
    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
//        arView.addObjects()
        arView.addAnchor()
        arView.addCoaching()

        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) {
        print("[AR] ExperienceStarted: \(experienceStarted)")
    }

}


extension ARView: ARCoachingOverlayViewDelegate {
    
    func addObjects() {
        if let anchor = self.scene.anchors.first as? BasicPlant.BasicPlantScene {
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

            for card in anchor.cardEntities {
                if let card = card as? Entity & HasCollision {
                    self.installGestures(.all, for: card)
                    print("[AR] the card has collistion")
                } else { print("[ARBAD] A Card doesn't have collision, check whether physics is enabled in reality kit") }
            }
        }
    }
    
    func addAnchor() {
        let anchor: BasicPlant.BasicPlantScene
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

        print("[AR] Adding coaching")
        self.addSubview(coachingOverlay)
    }
    // Example callback for the delegate object
    public func coachingOverlayViewDidDeactivate(
        _ coachingOverlayView: ARCoachingOverlayView
    ) {
        print("[AR] Overlay did deactivated, adding objects")
        self.addObjects()
    }
    
    
}
