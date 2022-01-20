//
//  View+Extensions.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI


extension View {
    func lExpanded() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func rExpanded() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func tExpanded() -> some View {
        frame(maxHeight: .infinity, alignment: .top)
    }
    
    func bExpanded() -> some View {
        frame(maxHeight: .infinity, alignment: .bottom)
    }
}
