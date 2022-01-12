//
//  NewItemView.swift
//  TODO
//
//  Created by huluobo on 2022/1/11.
//

import SwiftUI

struct NewItemView: View {
   
    @Binding var text: String
    let onSubmit: ((String) -> Void)?
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                Image(systemName: "calendar.badge.clock")
                    .font(.title3.bold())
            }
            .padding()
            .foregroundColor(Color.primary)

            TextField("Do what you want...", text: $text)
                .focused($isInputActive)
                .font(.body.weight(.medium))
                .foregroundColor(Pallet.primaryText)
                .padding(.trailing, 16)
                .padding(.vertical, 8)
                .onSubmit {
                    self.onSubmit?(text)
                    text = ""
                    isInputActive = true
                }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Pallet.systemBackground)
        .onChange(of: text) { value in
            isInputActive = !value.isAbsoluteEmpty
        }
            
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(text: Binding.constant("123")) { _ in
            
        }
    }
}
