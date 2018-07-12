//
//  Episode.swift
//  PodPlayer
//
//  Created by Athena on 7/10/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Foundation
import Cocoa

class Episode {
    var title = ""
    var pubDate = Date()
    var htmlDescription = ""
    var audioUrl = ""
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "us") as Locale
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
