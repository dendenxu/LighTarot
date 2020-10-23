//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

// FIXME: format stuff
import SwiftUI
import UIKit

struct ContentView: View {

    @EnvironmentObject var profile: UserProfile

    var body: some View {
        ZStack(alignment: .bottom) {
            if (profile.weAreInGlobal == .selector) {
                SelectorView()
                    .transition(.scale(scale: 0.001))
            } else if (profile.weAreInGlobal == .predictLight) {
                PredictLightView()
                    .transition(.scale(scale: 0.001))
            } else if (profile.weAreInGlobal == .arCamera) {
                ARCameraView()
                    .transition(.scale(scale: 0.001))
                    .onAppear {
                        print("Should have opened the camera or at least ask for permission by now")
                        // MARK: to actually make the application able to openup this ARScene, we're to imitate a simple AR project newly created
                        // and add ARKit requirements in info.plist
                        // add Privacy - ability to use camera to info.plist too

                }
            }
        }.edgesIgnoringSafeArea(.all)
        // FIXME: when using if to select between two global view, we'll get strange animation for MainPageContentView
        // Well, strangely we're able to fix this by adding a frame width limitation on MainPageContenView

    }
}

// Page changer
enum GlobalViewSelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .selector: return "selector"
        case .predictLight: return "predictLight"
        case .arCamera: return "arCamera"
        }
    }

    case selector
    case predictLight
    case arCamera
}

// Previewer
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}
