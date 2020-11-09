//
//  ARCameraView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/14.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import RealityKit
class Physics: Entity, HasPhysicsBody, HasPhysicsMotion {

    required init() {
        super.init()
        self.physicsBody = PhysicsBodyComponent(massProperties: .default,
                                                material: nil,
                                                mode: .kinematic)
        self.physicsMotion = PhysicsMotionComponent(linearVelocity: [0, 0, 0],
                                                    angularVelocity: [0, 3, 0])
    }
}

struct ARCameraView: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        let anchor: BasicPlant.BasicPlantScene
        do {
            try anchor = BasicPlant.loadBasicPlantScene()
            anchor.generateCollisionShapes(recursive: true)
            print("Information about anchor: \(anchor)")
            for child in anchor.children {
                child.transform.rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))
                print("Getting child: \(child)")
            }

            #if targetEnvironment(simulator)
            #else
                if let evilEye = anchor.evilEye {
                    print(evilEye)

                    if let evilEye = evilEye as? Entity & HasCollision {
                        arView.installGestures(.all, for: evilEye)
                        print("[AR] evilEye has collision")
                    }
                }


                if let theCard = anchor.theCard as? Entity & HasCollision {
                    arView.installGestures(.all, for: theCard)
                    print("[AR] theCard has collision")
                }


                if let theBox = anchor.theBox as? Entity & HasCollision {
                    arView.installGestures(.all, for: theBox)
                    print("[AR] theBox has collision")
                }
                arView.environment.sceneUnderstanding.options = [.occlusion, .physics]
            #endif
            arView.scene.anchors.append(anchor)


            print("The plant is successfully loaded to the anchor")
        } catch {
            print("Ah... Something went wrong, I think you're getting a black screen now.")
        }
        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) { }

}
