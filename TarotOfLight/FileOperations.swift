//
//  FileOperations.swift
//  TarotOfLight
//
//  Created by xzdd on 2020/10/21.
//  Copyright © 2020 xz. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserProfile {
    var name = "Default Name"
    var location = "Default Location"
    var birthday = Date(timeIntervalSince1970: TimeInterval(0))
    var energy = 15.0
    private var dateFormatter: DateFormatter {
        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "yyyy-mm-dd"
        return theFormatter
    }

    init(filename: String) {
        loadFromFile(filename: filename)
    }

    func loadFromFile(filename: String) {
        do {
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            let json = try JSON(data: Data(contentsOf: fileURL))
            name = json["name"].string ?? name
            location = json["location"].string ?? location
            birthday = dateFormatter.date(from: json["birthday"].stringValue) ?? birthday
            energy = json["energy"].double ?? energy
            print("User profile is successfully loaded.")
        } catch {
            print("Ah... Something went wrong. \(error)")
        }
    }

    func saveToFile(filename: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let json = JSON([
                "name": name,
                "location": location,
                "birthday": dateFormatter.string(from: birthday),
                "energy": energy
            ])
            try json.rawData().write(to: fileURL)
        } catch {
            print("Ah... Something went wrong. \(error)")
        }
    }

    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
