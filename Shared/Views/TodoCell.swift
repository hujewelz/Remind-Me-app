//
//  TodoCell.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

struct TodoCell: View {
    @Environment(\.managedObjectContext) private var viewContext
    let todo: Todo
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: todo.isCompleted ? "checkmark.diamond" : "diamond")
                .onTapGesture {
                    toggleCompleted()
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title!)
                    .font(.body)
                if todo.isRemind {
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
//                        Text(todo.dueDate!, style: .date)
                        Text(todo.isRemind ? "reminded" : "no")
                    }
                    .font(.caption)
                    .foregroundColor(.primary)
                }
            }
        }
        .tint(todo.isCompleted ? Color.gray : Color.primary)
        .padding(.vertical, 8)
    }
    
    private func toggleCompleted() {
        withAnimation {
            todo.isCompleted.toggle()
            try? viewContext.save()
        }
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


//struct TodoItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoItem(todo: )
//    }
//}
