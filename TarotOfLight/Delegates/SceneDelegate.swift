//
//  SceneDelegate.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

import UIKit
import SwiftUI


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var userProfile = LighTarotModel()
    var contentView: AnyView!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
//        userProfile =  // default name is profile.json
        contentView = AnyView(ContentView().environmentObject(userProfile))

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene did become disconnected")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene is now active")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene will now resign active")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Scene will now enter foreground")
        userProfile.sceneAtForeground = true
        userProfile.prepareHaptics()
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Scene is now at the background")
        userProfile.sceneAtForeground = false
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
//        let prevIsLandScape = userProfile.isLandScape
//        let currIsLandScape = windowScene.interfaceOrientation.isLandscape
//        userProfile.isLandScape = currIsLandScape // MARK: STUB
//        print("Getting landscape changing")
//        if currIsLandScape != prevIsLandScape {
//            let temp: CGFloat = .ScreenHeight
//            CGFloat.ScreenHeight = CGFloat.ScreenWidth
//            CGFloat.ScreenWidth = temp
//            print("IsLandScape Changed! Swapping, now .ScreenHeight is \(CGFloat.ScreenHeight) and .ScreenWidth is \(CGFloat.ScreenWidth)")
//        }
        // MARK: STUB NOW, DISABLED LANDSCAPE IN BUILD SETTINGS
    }

}

