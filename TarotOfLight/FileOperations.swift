//
//  FileOperations.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/21.
//  Copyright © 2020 xz. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftUI
class UserProfile:ObservableObject {
    @Published var name = "Default Name"
    @Published var location = "Default Location"
    @Published var avatar = "base64encoding" {
        didSet {
            print("Loading base64 encoded image from user profile as string")
            avatarImage = .fromBase64(base64: avatar)
        }
    }
    var avatarImage = UIImage()
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
    @Published var energy = 15.0
    @Published private var birthdayDate = Date(timeIntervalSince1970: TimeInterval(0))
    private var json = JSON()
    private var dateFormatter: DateFormatter {
        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "yyyy-mm-dd"
        return theFormatter
    }

    static private var getDocumentDirectory: URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    private let defaultProfileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "defaultProfile", ofType: "json") ?? "defaultProfile.json")
    
    init(filename: String = "profile.json") {
        loadFromFile(filename: filename)
    }

    func loadFromFile(filename: String = "profile.json") {
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

    func saveToFile(filename: String = "profile.json") {
        let fileURL = UserProfile.getDocumentDirectory.appendingPathComponent(filename)
        do {
            let json = JSON([
                "name": name,
                "location": location,
                "birthday": birthday,
                "energy": energy,
                "avatar": avatar
            ])
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

}
