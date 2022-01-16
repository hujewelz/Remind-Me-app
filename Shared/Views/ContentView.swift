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
                content(offset: inputViewHeight(of: proxy))
                NewItemView(text: $store.currenTodoTitle, onSubmit: store.addOrUpdateTodo(title:))
                    .offset(x: 0, y: screenHeight - proxy.safeAreaInsets.bottom - proxy.safeAreaInsets.top - inputViewHeight(of: proxy))
            }
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    private func content(offset: CGFloat) -> some View {
        NavigationView {
            TodoList(store: store)
            .padding(.bottom, offset)
            .navigationBarTitle(LocalizedStringKey(Localize.playYourDay.rawValue))
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
        .background(Pallet.gradientBg)
        .navigationViewStyle(StackNavigationViewStyle())
        .searchable(text: $store.searchText)
        
    }
    
    func inputViewHeight(of proxy: GeometryProxy) -> CGFloat {
        proxy.safeAreaInsets.bottom <= 34 ? (44 + 16) : NewItemView.height
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
