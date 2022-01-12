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
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                content(offset: 44)
                NewItemView(text: $store.currenTodoTitle, onSubmit: store.addOrUpdateTodo(title:))
                    .offset(x: 0, y: screenHeight - proxy.safeAreaInsets.bottom - proxy.safeAreaInsets.top - 44)
            }
            .tint(Pallet.tint)
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    private func content(offset: CGFloat) -> some View {
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
            .searchable(text: $store.searchText)
            .background(LinearGradient(colors: [Pallet.gradientStart, Pallet.gradientEnd],
                                       startPoint: UnitPoint(x: 0.5, y: 0),
                                       endPoint: UnitPoint(x: 0.5, y: 1))
            )
            .padding(.bottom, offset)
            .navigationBarTitle("This is your day!")
//            .sheet(item: $store.selectedTodo, onDismiss: {
//                
//            }, content: { todo in
//                //                NewTodoView(store: ToDoStore(context: viewContext, todo: selectedTodo))
//            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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
