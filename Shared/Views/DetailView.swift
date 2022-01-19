//
//  DetailView.swift
//  TODO
//
//  Created by huluobo on 2022/1/19.
//

import SwiftUI

struct DetailView: View {
    @State private var text = "take a nap"
    @State private var stepExpanded: Bool = false
    
    @State private var task = SubTask()
    @State private var note = ""
    @State private var isRemind = false
    
    @Environment(\.dismiss) var dismiss
    
    private var bellRotation: Double {
        isRemind ? 20 : 0
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Do what you want...", text: $text)
                        .font(.title3)
                        .padding(.vertical, 8)
                    
                    
                    SubTaskCell(text: $task.title, isCompleted: $task.isCompleted)
                    
                    addSubTaskRow
                }
                
                dateSection
                
                Section {
                    Button {
                        isRemind.toggle()
                        feedback()
                    } label: {
                        Label {
                            Text(isRemind ? "Don't Remind Me" : "Remind Me")
                        } icon: {
                            Image(systemName: isRemind ? "bell.slash.fill" : "bell")
                                .rotationEffect(Angle.degrees(bellRotation))
                                .animation(
                                    .interpolatingSpring(stiffness: 50, damping: 1)
                                        .speed(3),
                                    value: bellRotation)
                        }

                    }
                }
                
                Section("Add Note") {
                    TextEditor(text: $note)
                        .font(.callout)
                        .frame(minHeight: 100)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                    .disabled(text.isAbsoluteEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .background(Pallet.gradientBg)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var addSubTaskRow: some View {
        Button {
            
        } label: {
            Label("Add Step", systemImage: "plus")
        }
        
    }
    
    @State private var showDatePicker = false
    @State private var enableDueDate = true
    @State private var dueDate = Date()
    private var dateSection: some View {
        Section {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.vertical, 2)
                    .background(.red)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                    Text(dueDate.dateStr)
                        .foregroundColor(Pallet.secondary)
                        .font(.caption)
                }
                Spacer()
                Toggle("", isOn: $enableDueDate)
            }
            
            .frame(maxWidth: .infinity)
            .onTapGesture {
                withAnimation {
                    showDatePicker.toggle()
                }
            }
            if enableDueDate && showDatePicker {
                DatePicker("", selection: $dueDate, in: Date().../*, displayedComponents: [.date]*/)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
        }
    }
    
    func feedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
