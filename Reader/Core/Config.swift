//
//  Config.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//

import Foundation
enum Config {
    static var newsAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String else {
            fatalError("Missing NewsAPIKey in Info.plist")
        }
        return key
    }
}
