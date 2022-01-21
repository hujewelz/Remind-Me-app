//
//  Localize.swift
//  TODO
//
//  Created by huluobo on 2022/1/13.
//

import Foundation
import SwiftUI

enum Localize: String {
    case playYourDay = "play_your_day"
    case doWhatYouWant = "do_what_you_want"
    case cancel
    case search
    
    var key: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

extension Text {
    init(localized: Localize) {
        self.init(localized.key)
    }
}


