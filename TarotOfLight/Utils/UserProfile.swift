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
class UserProfile: ObservableObject {
    // Some animation configuration
    @Published var sceneAtForeground = true
    
    // Navigation data, updating the view by selecting different enum value for these
    @Published var lockingSelection: LockingSelection = .unlocked
    @Published var weAreIn: PredictLightViewSelection = .category
    @Published var weAreInGlobal: GlobalViewSelection = .selector
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
    @Published var energy = 15.0 // Max: 100.0 as Double type
    @Published private var birthdayDate = Date(timeIntervalSince1970: TimeInterval(0))

    // Card informations from default json file
    // Defines whether user has unlocked certain cards
    @Published var cardInfos: [CardInfo] = [CardInfo]()
    @Published var cardSets: [Card] = [Card]()


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

    private let defaultProfileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "DefaultProfile", ofType: "json") ?? "DefaultProfile.json")

    init(filename: String = "profile.json", cardInfoFilename: String = "CardInfo.json") {
        loadUserInfoFromFile(filename: filename)
        loadCardInfoFromFile(filename: cardInfoFilename)
        validateCardInfo()
        prepareHaptics()
    }

    func loadCardInfoFromFile(filename: String = "CardInfo.json") {
        // MARK: More to be added here for loading information from the CardInfo.json profile
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "") ?? filename)
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

    func loadUserInfoFromFile(filename: String = "profile.json") {
        var fileURL = UserProfile.getDocumentDirectory.appendingPathComponent(filename)
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
    }

    func saveUserInfoToFile(filename: String = "profile.json") {
        let fileURL = UserProfile.getDocumentDirectory.appendingPathComponent(filename)
        let json = JSON([
            "name": name,
            "location": location,
            "birthday": birthday,
            "energy": energy,
            "avatar": avatar
        ])
        do {
            try json.rawData().write(to: fileURL)
            print("Done! User profile data is saved now.")
        } catch {
            print("Ah... Something went wrong. \(error)")
        }
    }

    static func deleteFile(filename: String = "profile.json") {
        let fileURL = getDocumentDirectory.appendingPathComponent(filename)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Cannot delete the file specified. \(error)")
        }
    }

    @Published private var engine: CHHapticEngine?

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

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
