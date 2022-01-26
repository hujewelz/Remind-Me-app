//
//  Tag.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import Foundation
import SwiftUI

public struct Tag {
    public let id: UUID
    public let text: String
    public let color: TagColor
    
    public enum TagColor: String, Codable, CaseIterable {
        case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, brown, sysBg
    }
}

extension Tag: Codable {}
extension Tag: Identifiable {}

extension Tag {
    public init(text: String, color: Color) {
        id = UUID()
        self.text = text
        self.color = TagColor(color: color)
    }
    
    init(tagMO: TagMO) {
        self.init(id: tagMO.id!, text: tagMO.title!, color: TagColor(rawValue: tagMO.color!) ?? .sysBg)
    }
}

extension Tag.TagColor {
    public init(color: Color) {
        switch color {
        case .red:
            self = .red
        case .orange:
            self = .orange
        case .yellow:
            self = .yellow
        case .green:
            self = .green
        case .mint:
            self = .mint
        case .teal:
            self = .teal
        case .cyan:
            self = .cyan
        case .blue:
            self = .blue
        case .indigo:
            self = .indigo
        case .purple:
            self = .purple
        case .pink:
            self = .pink
        case .brown:
            self = .brown
        default:
            self = .sysBg
        }
    }
    
    public var color: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .mint:
            return .mint
        case .teal:
            return .teal
        case .cyan:
            return .cyan
        case .blue:
            return .blue
        case .indigo:
            return .indigo
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .brown:
            return .brown
        case .sysBg:
            return Color(uiColor: .systemBackground)
        }
    }
}

