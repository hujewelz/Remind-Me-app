//
//  SubTaskCell.swift
//  TODO
//
//  Created by huluobo on 2022/1/19.
//

import SwiftUI

struct SubTaskCell: View {
    @Binding var text: String
    @Binding var isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation {
                    isCompleted.toggle()
                }
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
            }
            TextField("Add tasks", text: $text)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Pallet.iconPrimary)
            }
//            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct SubTaskCell_Previews: PreviewProvider {
    static var previews: some View {
        SubTaskCell(text: .constant("Take a nap"), isCompleted: .constant(false))
            .frame(width: 360.0, height: 60.0)
            
    }
}
