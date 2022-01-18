//
//  NewItemView.swift
//  TODO
//
//  Created by huluobo on 2022/1/11.
//

import SwiftUI

struct NewItemView: View {
    
    static var height: CGFloat = 88 + 16
   
    @Binding var text: String
    let onSubmit: ((String) -> Void)?
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Do what you want...", text: $text)
                .submitLabel(.done)
                .focused($isInputActive)
                .font(.body.weight(.medium))
                .foregroundColor(Pallet.primary)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .onSubmit {
                    self.onSubmit?(text)
                    text = ""
                    isInputActive = false
                }
        
            InputToolBar()
                 .opacity(alpha)
                 .animation(.linear(duration: 0.2), value: alpha)
            
        }
        
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Pallet.systemBackground)
    }
    
    var alpha: Double {
        isInputActive ? 1 : 0
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(text: Binding.constant("123")) { _ in
            
        }
    }
}
