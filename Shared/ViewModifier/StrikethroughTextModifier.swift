//
//  StrikethroughTextModifier.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import SwiftUI


extension Text {
    func strikethroughable(_ isStrikethrough: Bool = false) -> Text {
        isStrikethrough ? self.strikethrough() : self
    }
}
