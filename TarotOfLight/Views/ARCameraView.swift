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
//            anchor.setOrientation(simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 0, 1)), relativeTo: nil)
//            anchor.transform = Transform(matrix: simd_float4x4(SIMD4<Float>(1,0,0,0), SIMD4<Float>(0,1,0,0), SIMD4<Float>(0,0,1,0), SIMD4<Float>(1,1,1,0)))
            print("Information about anchor: \(anchor)")
//            anchor.transform.rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0))
            for child in anchor.children {
//                child.setOrientation(simd_quatf(angle: 0, axis: SIMD3<Float>(1, 1, 1)), relativeTo: nil)
//                child.transform.translation = SIMD3<Float>(10, 10, 10)
                child.transform.rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))
                print("Getting child: \(child)")
            }

//            #if PREVIEW
//            #else
////            let physics = Physics()
////            let kinematicComponent: PhysicsBodyComponent = physics.physicsBody!
////            let motionComponent: PhysicsMotionComponent = physics.physicsMotion!
//                if let evilEye = anchor.evilEye {
//
////                let evilEyeClone = evilEye.clone(recursive: true)
////                let parentEntity = ModelEntity()
////                parentEntity.addChild(evilEye)
////                anchor.addChild(evilEyeClone)
//
////                evilEye.components.set(kinematicComponent)
////                evilEye.components.set(motionComponent)
//                    print(evilEye)
//
////                arView.installGestures(.all, for: parentEntity)
//
////                evilEye.setParent(parentEntity)
////                anchor.addChild(parentEntity)
//
//                    if let evilEye = evilEye as? Entity & HasCollision {
//                        arView.installGestures(.all, for: evilEye)
//                        print("Has Collision")
//                    }
//
////                if let evilEye = evilEyeClone as? Entity & HasCollision {
////                    arView.installGestures(.all, for: evilEye)
////                    print("Has Collision")
////                }
//
//                }
//
//
//                if let theCard = anchor.theCard as? Entity & HasCollision {
//                    arView.installGestures(.all, for: theCard)
//                }
//
//
//                if let theBox = anchor.theBox as? Entity & HasCollision {
//                    arView.installGestures(.all, for: theBox)
//                }
////            if let anchor = anchor as? HasCollision & Entity {
////                print("The anchor has collision")
////                arView.installGestures(.all, for: anchor)
////            }
//            #endif
            arView.scene.anchors.append(anchor)


            print("The plant is successfully loaded to the anchor")
        } catch {
            print("Ah... Something went wrong, I think you're getting a black screen now.")
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) { }

}
