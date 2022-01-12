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

    
    @ObservedObject var store: ToDoStore
    
    @State private var isPresented = false
    @State private var selectedTodo: Todo?
    
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                content
                NewItemView(onSubmit: addNewTodo(title:))
                .offset(x: 0, y: screenHeight - proxy.safeAreaInsets.bottom - proxy.safeAreaInsets.top - 44)
            }
            .tint(Pallet.tint)
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    var content: some View {
        NavigationView {
            List {
                ForEach(store.todos, id: \.title) { section in
                    Section(header: Text(section.title.rawValue)
                                .foregroundColor(Color.secondary)
                                .font(.subheadline.bold())
                    ) {
                       ForEach(section.value) { todo in
                           TodoCell(todo: todo) {
                               store.toggleCompletion(todo)
                           }
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
            .background(LinearGradient(colors: [Pallet.gradientStart, Pallet.gradientEnd],
                                       startPoint: UnitPoint(x: 0.5, y: 0),
                                       endPoint: UnitPoint(x: 0.5, y: 1))
            )
            .searchable(text: $searchText)
            .navigationBarTitle("This is your day!")
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $isPresented, onDismiss: {
                selectedTodo = nil
            }, content: {
                //                NewTodoView(store: ToDoStore(context: viewContext, todo: selectedTodo))
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .onChange(of: searchText, perform: { _ in
            
        })
    }
    
    private func addNewTodo(title: String) {
        let todo = Todo(title: title)
        store.create(todo)
    }
    
   
    private func delete(at indexSet: IndexSet) {
        print("index set: ", indexSet)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
