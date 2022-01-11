//
//  NewTodoView.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

struct NewTodoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var steps: [String] = []
    
    @ObservedObject var store: ToDoStore
   
    var body: some View {
#if os(iOS)
        NavigationView {
            content
        }
#else
        content
#endif
    }
    
    var content: some View {
        List {
            Section {
                TextField("I want...", text: $store.title)
                Button {
                    steps.append("")
                } label: {
                    Label("Add Step", systemImage: "plus")
                }
            }
            
            Section {
                Button(action: store.toggleRemind) {
                    Label {
                        Text(store.isRemind ? "Don't Remind Me" : "Remind Me")
                    } icon: {
                        Image(systemName: store.isRemind ? "bell.fill" : "bell")
                            .rotationEffect(Angle.degrees(store.bellRotation))
                            .animation(
                                .interpolatingSpring(stiffness: 50, damping: 1)
                                    .speed(3),
                                value: store.bellRotation)
                    }

                }
                HStack {
                    Label {
                        DatePicker("Due Date", selection: $store.duteData, in: dateRange)
                                .labelsHidden()
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
            }
            
            Section("Add Note") {
                TextEditor(text: $store.content)
                    .font(.callout)
                    .frame(minHeight: 100)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: saveItem) {
                    Text("Save")
                        .bold()
                }
                .disabled(store.title.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
    
    private func saveItem() {
        store.saveItem()
        presentationMode.wrappedValue.dismiss()
    }
    
    let dateRange: ClosedRange<Date> = Date()...Date.distantFuture
}

//struct NewTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTodoView()
//    }
//}
