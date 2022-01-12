//
//  Pallet.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import SwiftUI
import UIKit

enum Pallet {
    static let tint = Color.purple
    static let primaryText = Color.purple
    static let secondaryText = Color(uiColor: .systemGray2)
    static let systemBackground = Color(uiColor: .systemBackground)
    
    static let gradientStart = Color(uiColor: UIColor(dynamicProvider: { colletction in
        return colletction.userInterfaceStyle == .light
            ? UIColor(red: 252.0/255, green: 241.0/255, blue: 234.0/255, alpha: 1.0)
            : UIColor(red: 252.0/255, green: 241.0/255, blue: 234.0/255, alpha: 1.0)
    }))
    
    static let gradientEnd = Color(uiColor: UIColor(dynamicProvider: { colletction in
        return UIColor.systemBackground
    }))
}
