//
//  ContentView.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI
import CoreData

let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Todo>
    
    @SectionedFetchRequest<Bool, Todo>(
        sectionIdentifier: \Todo.isCompleted,
        sortDescriptors: [SortDescriptor(\Todo.timestamp, order: .reverse)]
    )
    private var items: SectionedFetchResults<Bool, Todo>
    @State private var isPresented = false
    @State private var selectedTodo: Todo?
    
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                content
                NewItemView()
                    .offset(x: 0, y: screenHeight - proxy.safeAreaInsets.bottom - proxy.safeAreaInsets.top - 44)
            }
        }
    }
    
    var content: some View {
        NavigationView {
            List {
                ForEach(items.reversed()) { section in
                    Section(header: Text(section.id ? "Completed" : "Todo")
                                .foregroundColor(Color.secondary)
                                .font(.subheadline)
                    ) {
                        ForEach(section) { todo in
                            TodoCell(todo: todo)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .swipeActions(content: {
                                    Button(role: .destructive) {
                                        deleteTodo(todo)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        toggleRemind(todo)
                                    } label: {
                                        if todo.isRemind {
                                            Label("Silent", systemImage: "bell.fill")
                                        } else {
                                            Label("Remind", systemImage: "bell.slash.fill")
                                        }
                                    }
                                    .tint(Color.orange)
                                })
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(LinearGradient(colors: [Color(red: 252.0/255, green: 241.0/255, blue: 234.0/255), Color.white],
                                       startPoint: UnitPoint(x: 0.5, y: 0),
                                       endPoint: UnitPoint(x: 0.5, y: 1))
            )
            .searchable(text: $searchText)
            .navigationBarTitle("This is your day!")
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $isPresented, onDismiss: {
                selectedTodo = nil
            }, content: {
                NewTodoView(store: ToDoStore(context: viewContext, todo: selectedTodo))
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .onChange(of: searchText, perform: { _ in
            
        })
        
        .tint(Color.purple)
        .onAppear {
//            UINavigationBar.appearance().backgroundColor = UIColor(hue: 0.086, saturation: 0.29, brightness: 0.95, alpha: 1)
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    private func addItem() {
        isPresented = true
    }
    
    private func toggleTodoIsCompleted(_ todo: Todo) {
        todo.isCompleted.toggle()
        try? viewContext.save()
    }
    
    private func toggleRemind(_ todo: Todo) {
        todo.isRemind.toggle()
        try? viewContext.save()
    }
    
    private func deleteTodo(_ todo: Todo) {
        viewContext.delete(todo)
        try? viewContext.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
