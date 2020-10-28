//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//
//  This is the rootView for our application LighTarot
//  It acts like a container for three other subViews:
//  1. SelectorView which is basically our main page, mine page and the interface for opening the ARCamera

// FIXME: format stuff
import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var profile: LighTarotModel
    var body: some View {
        ZStack(alignment: .bottom) {
            if (profile.weAreInGlobal == .selector) {
                if profile.weAreInSelector == .mainPage { Color(profile.energy >= 100.0 ? "MediumDarkPurple" : "LightGray") }
                else if profile.weAreInSelector == .cardPage { Color("MediumDarkPurple") }
                else if profile.weAreInSelector == .minePage { Color("LightGray") }
                SelectorView()
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .transition(scaleTransition)
            } else if (profile.weAreInGlobal == .predictLight) {
                if (profile.weAreIn == .animation) { Color("MediumDarkPurple") }
                else if (profile.weAreIn == .category) { Color("LightMediumDarkPurple") }
                PredictLightView()
                // BUG: When the frame is set here, this subView will be placed a mysterious offset
                // I ... I don't know how to fix it, temporarity I'm just ignoring it.
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .transition(scaleTransition)
            } else if (profile.weAreInGlobal == .arCamera) {
                ARCameraView()
                    .transition(scaleTransition)
                    .onAppear {
                        print("Should have opened the camera or at least ask for permission by now")
                        // MARK: to actually make the application able to openup this ARScene, we're to imitate a simple AR project newly created
                        // 1. add ARKit requirements in info.plist
                        // 2. add Privacy - ability to use camera to info.plist too
                }
            } else if (profile.weAreInGlobal == .introduction) {
                // Background Rectangle
                RoundedRectangle(cornerRadius: .ScreenCornerRadius).foregroundColor(Color("LightGray"))
                IntroPageView()
                    .transition(scaleTransition)
            }
        }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(.all)
        // Setting frame and cornerRadius clip here is a more global approach for the who main page
        // Adding edges ignorance operations here at the rootView will rid all subViews of the safe areas

    }
}

// Page changer
enum GlobalViewSelection: CustomStringConvertible {
    var description: String {
        switch self {
        case .selector: return "selector"
        case .predictLight: return "predictLight"
        case .arCamera: return "arCamera"
        case .introduction: return "introduction"
        }
    }

    case selector
    case predictLight
    case arCamera
    case introduction
}
