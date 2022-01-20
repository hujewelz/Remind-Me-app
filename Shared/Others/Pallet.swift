//
//  Pallet.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import SwiftUI
import UIKit

enum Pallet {
    static let primary = Color(uiColor: UIColor(named: "primary")!)
    static let secondary = Color(uiColor: UIColor(named: "secondary")!)
    static let tertiary = Color(uiColor: UIColor(named: "tertiary")!)
    static let systemBackground = Color(uiColor: .systemBackground)
    static let systemGroupedBackground = Color(uiColor: .systemGroupedBackground)
    static let iconPrimary = Color(uiColor: UIColor(named: "iconPrimary")!)
    
    static let gradientStart = Color(uiColor: UIColor(named: "gradientStart")!)
    static let gradientEnd = Color(uiColor: UIColor(named: "gradientEnd")!)
    
    
    static let gradientBg = LinearGradient.linearGradient(colors: [Pallet.gradientStart, Pallet.gradientEnd],
                                                          startPoint: UnitPoint.topTrailing,
                                                          endPoint: UnitPoint.bottomLeading)
}



