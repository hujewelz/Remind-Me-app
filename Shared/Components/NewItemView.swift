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
                .frame(height: 44)
                .onSubmit {
                    self.onSubmit?(text)
                    text = ""
                    isInputActive = false
                }
        
            toolBar
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Pallet.systemBackground)
    }
    
    var alpha: Double {
        isInputActive ? 1 : 0
    }
    
    var toolBar: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                
            } label: {
                Image(systemName: "calendar.badge.clock")
            }
          
            
            Button {
                
            } label: {
                Image(systemName: "bell")
            }
            
            
            Spacer()
        }
        .tint(Pallet.iconPrimary)
        .font(.title3.weight(.bold))
        .frame(height: 44)
        .opacity(alpha)
        .animation(.linear(duration: 0.2), value: alpha)
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(text: Binding.constant("123")) { _ in
            
        }
    }
}
