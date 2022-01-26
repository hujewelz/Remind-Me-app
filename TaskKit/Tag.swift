//
//  Tag.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import Foundation
import SwiftUI

struct Tag {
    let id: UUID
    let text: String
    let color: String
}

extension Tag: Codable {}
extension Tag: Identifiable {}
