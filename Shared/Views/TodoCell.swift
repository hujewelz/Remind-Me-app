//
//  TodoCell.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

struct TodoCell: View {
    let todo: Todo
    let onCheck: (() -> Void)?
    
    @State private var isPresented = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: todo.isCompleted ? "checkmark.diamond" : "diamond")
                .font(.title2.weight(.medium))
                .foregroundColor(textColor)
                .onTapGesture {
                    self.onCheck?()
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethroughable(todo.isCompleted)
                    .lineLimit(2)
                    .font(.body)
                    .foregroundColor(textColor)
                
                if todo.dueDate != nil {
                    HStack(spacing: 2) {
                        Text(todo.dueDate!.dateStr)
                        if todo.isRemind {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 8))
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Pallet.secondary)
                }
            }
            Spacer()
            
            Button {
               isPresented = true
            } label: {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(Pallet.iconPrimary)
            }

        }
        .tint(textColor)
        .padding(.vertical, 8)
        .sheet(isPresented: $isPresented, onDismiss: nil) {
           DetailView()
        }
    }
    
    var textColor: Color {
        todo.isCompleted ? Pallet.tertiary : Pallet.primary
    }
}



//struct TodoItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoItem(todo: )
//    }
//}
