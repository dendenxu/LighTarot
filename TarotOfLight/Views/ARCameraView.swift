//
//  ARCameraView.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/14.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import RealityKit

struct ARCameraView: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        let anchor: BasicPlant.BasicPlantScene
        do {
            try anchor = BasicPlant.loadBasicPlantScene()
            anchor.generateCollisionShapes(recursive: true)
            arView.scene.anchors.append(anchor)
            print("The plant is successfully loaded to the anchor")
        } catch {
            print("Ah... Something went wrong, I think you're getting a black screen now.")
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) { }

}
