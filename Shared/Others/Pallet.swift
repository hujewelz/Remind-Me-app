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
    
    static let red = Color(r: 229, g: 21, b: 21, alpha: 1.0)
    static let deepBlue = Color(r: 116, g: 24, b: 232, alpha: 1.0)
    static let purple = Color(r: 171, g: 6, b: 198, alpha: 1.0)
    
    static let colorfull = [Pallet.red, Pallet.deepBlue, Pallet.purple]
    
    static let linearGradient = LinearGradient(colors: Pallet.colorfull,
                                                          startPoint: UnitPoint.leading,
                                                          endPoint: UnitPoint.trailing)
    
    static let angluarGradient = AngularGradient(colors: Pallet.colorfull, center: .center, angle: .degrees(360))
}

extension Color {
    init(r: UInt8, g: UInt8, b: UInt8, alpha: Double) {
        self.init(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0, opacity: alpha)
    }
}


