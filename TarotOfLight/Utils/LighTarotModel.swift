//
//  FileOperations.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/21.
//  Copyright © 2020 xz. All rights reserved.
//

import Foundation
import CoreHaptics
import SwiftyJSON
import SwiftUI
class LighTarotModel: ObservableObject {
    // MARK: Debugger view enabled?
    let showDebuggerAtLaunch = false
    // Some animation configuration
    // Currently not used in the code, for lottie animation, we're using builtin settings instead
    @Published var shouldShowEnergy = false
    @Published var sceneAtForeground = true
    @Published var selectorShouldChange = false
    @Published var shouldShowNewCardView: Bool = false
    @Published var isLandScape: Bool = false

    var selectorIsChanged: Bool { proficientUser && selectorShouldChange }

    // Navigation data, updating the view by selecting different enum value for these
    @Published var lockingSelection: LockingSelection = .unlocked
    @Published var weAreIn: PredictLightViewSelection = .category
    @Published var weAreInGlobal: GlobalViewSelection = .debugger
    @Published var weAreInCategory: CategorySelection = .love
    @Published var weAreInSelector: SelectorSelection = .mainPage


    // Information about the current user
    @Published var name = "Default Name"
    @Published var location = "Default Location"
    @Published var avatar = "base64encoding" {
        didSet { // didSet will be called even when we're initializing
            print("Loading base64 encoded image from user profile as string")
            avatarImage = .fromBase64(base64: avatar)
        }
    }
    // Computed value (manually updated value to reserve the resource)
    var avatarImage = UIImage() // Precomputation to speed things up
    var energy: Double { // Max: 100.0 as Double type
        get { actualEnergy }
        set {
            if newValue > 100 {
                actualEnergy = 100
                // MARK: Or should I
//                withAnimation(springAnimation) {
//                    shouldShowNewCardView = true
//                }
            }
            else if newValue < 0 { actualEnergy = 0 }
            else {
                actualEnergy = newValue
//                shouldShowNewCardView = false
            }
        }
    }
    @Published var actualEnergy: Double = 15.0
    @Published var proficientUser: Bool = false
    @Published private var birthdayDate = Date(timeIntervalSince1970: TimeInterval(0))
    var birthday: String {
        get {
            return dateFormatter.string(from: birthdayDate)
        }
        set {
            if let triedDate = dateFormatter.date(from: newValue) {
                birthdayDate = triedDate
                print("Successfully loaded newly added birthday from string")
            } else {
                print("Cannot pharse string as Date of format \(String(describing: dateFormatter.dateFormat))")
            }
        }
    }

    // Card informations from default json file
    // Defines whether user has unlocked certain cards
    @Published var cardInfos: [CardInfo] = [CardInfo]()
    @Published var cardContents: [CardContent] = [CardContent]()
    var lockedTexts: [CardContent] {

        var lockedContents = [CardContent]()
        for item in cardContents { if (item.locked) { lockedContents.append(item) } }
        return lockedContents

    }

    var firstLocked: Int {
        for index in 0..<cardContents.count {
            if cardContents[index].locked {
                return index
            }
        }
        return 0
    }

    var hasLocked: Bool {
        let locked = firstLocked
        return cardContents[locked].locked // traversing in firstLocked, if firstLocked is unlocked, there's no locked left
    }

    // Convenience variable for loading JSON data
    private var json = JSON()

    // Our dataformatter
    private var dateFormatter: DateFormatter {
        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "yyyy-mm-dd"
        return theFormatter
    }

    // Document directory that will get deleted once the user deleted the APP
    static private var getDocumentDirectory: URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }

    // Default user profile location, located in Profiles/DefaultProfile.json
    private let defaultProfileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "DefaultProfile", ofType: "json") ?? "DefaultProfile.json")

    // Contruct the user profile, it's actually a model
    // The view controller is taken care of by SwiftUI
    init(filename: String = "profile.json", cardInfoFilename: String = "CardInfo.json", cardContentFileName: String = "CardContent.json") {
        loadUserInfoFromFile(filename: filename)
        loadCardInfoFromFile(filename: cardInfoFilename)
        loadCardContentFromFile(filename: cardContentFileName)
        validateCardInfo(count: 5)
        prepareHaptics()
        prepareView()
    }

    func prepareView() {
        lockingSelection = .unlocked
        weAreIn = .category
        weAreInGlobal = showDebuggerAtLaunch ? .debugger : (proficientUser ? .selector : .introduction)
        weAreInCategory = .love
        weAreInSelector = .mainPage
    }

    func saveCardContentToFile(filename: String = "CardContent.json") {
        print("STUB: Should implement saving cardContent here!")
        let fileURL = LighTarotModel.getDocumentDirectory.appendingPathComponent(filename)
        var jsonArray = [JSON]() // MARK: Or should I use array?
        for item in cardContents {
            jsonArray.append(JSON(
                [
                    "text": item.text,
                    "energy": item.energy,
                    "description": item.description,
                    "locked": item.locked,
                    "lockedImageName": item.lockedImageName,
                    "unlockedImageName": item.unlockedImageName
                ]
            ))
        }
        let json = JSON(jsonArray)
        do {
            try json.rawData().write(to: fileURL)
            print("Done! Card content data is saved now.")
        } catch {
            print("Ah... Something went wrong. \(error)")
        }
    }

    func loadCardContentFromFile(filename: String = "CardContent.json") {
        var fileURL = LighTarotModel.getDocumentDirectory.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "") ?? filename)
        }
        // MARK: More to be added here for loading information from the CardInfo.json profile
//        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "") ?? filename)
        do {
            json = try JSON(data: Data(contentsOf: fileURL))
            print("CardInfo.json is successfully loaded from \(fileURL)")
        } catch {
            print("Cannot find user specified location for loading profile. \(error)")
        }
        for entry in json.array ?? [JSON()] {
            cardContents.append(
                CardContent(
                    text: entry["text"].string ?? CardContent.default.text,
                    description: entry["description"].string ?? CardContent.default.description,
                    energy: entry["energy"].double ?? CardContent.default.energy,
                    locked: entry["locked"].bool ?? CardContent.default.locked,
                    lockedImageName: entry["lockedImageName"].string ?? CardContent.default.lockedImageName,
                    unlockedImageName: entry["unlockedImageName"].string ?? CardContent.default.unlockedImageName
                )
            )
        }
    }

    // Lood card info, like a full card description and some other things
    func loadCardInfoFromFile(filename: String = "CardInfo.json") {
        var fileURL = LighTarotModel.getDocumentDirectory.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "") ?? filename)
        }
        // MARK: More to be added here for loading information from the CardInfo.json profile
        do {
            json = try JSON(data: Data(contentsOf: fileURL))
            print("CardInfo.json is successfully loaded from \(fileURL)")
        } catch {
            print("Cannot find user specified location for loading profile. \(error)")
        }
        for entry in json.array ?? [JSON()] {
            cardInfos.append(
                CardInfo(
                    name: entry["name"].string ?? CardInfo.default.name,
                    flipped: entry["flipped"].bool ?? CardInfo.default.flipped,
                    imageName: entry["imageName"].string ?? CardInfo.default.imageName,
                    interpretText: entry["interpretText"].string ?? CardInfo.default.interpretText,
                    storyText: entry["storyText"].string ?? CardInfo.default.storyText,
                    energy: entry["energy"].int ?? CardInfo.default.energy
                )
            )
        }
    }

    // Make sure that the number of cards available is at least 3 or other value
    func validateCardInfo(count: Int = 3) {
        print("Current loading static information from the json file to be displayed on the screen")

        if cardInfos.count < count {
            print("This is uncool, gap of \(count - cardInfos.count) to be filled")
            for _ in 0..<(count - cardInfos.count) {
                print("Since there's \(count) guys to be displayed, we hereby check the number of available cards inside, fill the up with \(CardInfo.default)")
                cardInfos.append(.default)
            }
        }
    }

    // Load use profile, including the user avatar
    // Saved as base64jpeg data of string
    func loadUserInfoFromFile(filename: String = "profile.json") {
        var fileURL = LighTarotModel.getDocumentDirectory.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            fileURL = defaultProfileURL
        }
        do {
            json = try JSON(data: Data(contentsOf: fileURL))
            print("User profile is successfully loaded from \(fileURL)")
        } catch {
            print("Cannot find user specified location for loading profile. \(error)")
        }
        name = json["name"].string ?? name
        location = json["location"].string ?? location
        birthday = json["birthday"].string ?? birthday
        energy = json["energy"].double ?? energy
        avatar = json["avatar"].string ?? avatar
        proficientUser = json["proficientUser"].bool ?? proficientUser
    }

    // User might have already made change to the profile, save it to profile.json under document directory
    // which will get deleted when APP is deleted
    func saveUserInfoToFile(filename: String = "profile.json") {
        let fileURL = LighTarotModel.getDocumentDirectory.appendingPathComponent(filename)
        let json = JSON([
            "name": name,
            "location": location,
            "birthday": birthday,
            "energy": energy,
            "proficientUser": proficientUser,
            "avatar": avatar,
        ])
        do {
            try json.rawData().write(to: fileURL)
            print("Done! User profile data is saved now.")
        } catch {
            print("Ah... Something went wrong. \(error)")
        }
    }

    // Developer command for deleteing the user profile to debug
    static func deleteDocumentFile(filename: String = "profile.json") {
        let fileURL = getDocumentDirectory.appendingPathComponent(filename)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Cannot delete the file specified. \(error)")
        }
    }

    // The Haptic Engine to be used across all the scene
    @Published var engine: CHHapticEngine?

    // The name explains itself
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    // A intense but short completion haptic
    // Can happen multiple times
    func pagerSuccess(count: Int = 1) {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)

        print("Current count is \(count), should play multiple Haptics")

        var relativeTime: Double = 0

        for _ in 0..<count {
            let newEvent = CHHapticEvent(eventType: .hapticTransient, parameters:
                [
                    intensity,
                    sharpness,
                ],
            relativeTime: relativeTime)
            events.append(newEvent)
            relativeTime += 0.05
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }


    // A sharp, short burst of haptics vibration to give user some feedback of their operation
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters:
            [
                intensity,
                sharpness,
            ],
        relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
