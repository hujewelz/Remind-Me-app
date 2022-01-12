//
//  NewItemView.swift
//  TODO
//
//  Created by huluobo on 2022/1/11.
//

import SwiftUI

struct NewItemView: View {
    
    let onSubmit: ((String) -> Void)?
    @State private var text = ""
    
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
                .font(.body.bold())
                .padding(.trailing, 16)
                .padding(.vertical, 8)
                .onSubmit {
                    self.onSubmit?(text)
                    text = ""
                }
        }
        
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Pallet.systemBackground)
            
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView { _ in
            
        }
    }
}
