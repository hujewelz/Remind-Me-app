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
                
                if !todo.isCompleted && todo.dueDate != nil {
                    HStack(spacing: 2) {
                        Text(todo.dueDate!, style: .date)
                        if todo.isRemind {
                            Image(systemName: "bell")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Pallet.secondaryText)
                }
            }
            Spacer()
            
        }
        .tint(textColor)
        .padding(.vertical, 8)
    }
    
    var textColor: Color {
        todo.isCompleted ? Pallet.secondaryText : Pallet.primaryText
    }
}



//struct TodoItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoItem(todo: )
//    }
//}
