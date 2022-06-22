//
//  TextFieldClearButtonModifier.swift
//  TODO (iOS)
//
//  Created by luobobo on 2022/6/22.
//

import SwiftUI

struct TextFieldClearButtonModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
            }
        }
    }
}

extension TextField {
    func clearButton(_ text: Binding<String>) -> some View {
        modifier(TextFieldClearButtonModifier(text: text))
    }
}
