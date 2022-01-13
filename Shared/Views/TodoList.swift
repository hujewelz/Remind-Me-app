//
//  TodoList.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import SwiftUI

struct TodoList: View {
    @ObservedObject var store: ToDoStore
    
    var body: some View {
        List {
            ForEach(store.todos, id: \.title) { section in
                Section(header: Text(section.title.rawValue)
                            .foregroundColor(Color.secondary)
                            .font(.subheadline.weight(.bold))
                ) {
                    ForEach(section.value) { todo in
                        TodoCell(todo: todo) {
                            store.toggleCompletion(todo)
                        }
                        .onTapGesture(perform: {
                            store.currenTodoTitle = todo.title
                            store.selectedTodo = todo
                        })
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(content: {
                            Button(role: .destructive) {
                                store.delete(todo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(Color.red)
                            
                            if !todo.isCompleted {
                                Button {
                                    store.toggleRemind(todo)
                                } label: {
                                    if todo.isRemind {
                                        Label("Silent", systemImage: "bell.slash.fill")
                                    } else {
                                        Label("Remind", systemImage: "bell.fill")
                                    }
                                }
                                .tint(Color.orange)
                            }
                        })
                    }
                    .onDelete(perform: delete(at:))
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(Pallet.gradientBg)
    }
    
    private func delete(at indexSet: IndexSet) {
        print("index set: ", indexSet)
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList(store: ToDoStore(service: PersistenceController()))
    }
}
