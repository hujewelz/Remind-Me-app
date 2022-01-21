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
    
    let onSubmint: (() -> Void)?
    let onDelete: (() -> Void)?
    
    @FocusState private var isInputActive
    
    init(_ text: Binding<String>,
         isCompleted: Binding<Bool>,
         onDelete: (() -> Void)? = nil,
         onSubmit: (() -> Void)? = nil) {
        _text = text
        _isCompleted = isCompleted
        self.onDelete = onDelete
        self.onSubmint = onSubmit
    }
    
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
                .submitLabel(.next)
                .focused($isInputActive)
                .font(.body.weight(.regular))
                .onSubmit {
                    onSubmint?()
                }
            
            Spacer()
            
            Button {
                onDelete?()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .foregroundColor(Pallet.iconPrimary)
            }
            .padding(.vertical, 8)
        }.onAppear {
            isInputActive = true
        }
    }
}

struct SubTaskCell_Previews: PreviewProvider {
    static var previews: some View {
        SubTaskCell(.constant("Take a nap"), isCompleted: .constant(false))
    }
}
