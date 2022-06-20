//
//  NewTaskView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI
import TaskKit

struct NewTaskView: View {
    @State private var title = "Weekly Scrnm Meeting plan you day day day"
    @State private var startTime = Date()
    @State private var endTime = Date().advanced(by: 3600)
    @State private var isRepeated = false
    @State private var isReminded = false
    @State private var enableLocation = false
    @FocusState private var isInputActive: Bool
    
    @State private var subTasks: [SubTask] = []
    @State private var isPresented = false
    
    @State private var note = ""
    
    var body: some View {
        ModalView {
            content
        }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                groupedContent {
                    TextEditor(text: $title)
                        .lineLimit(2)
                        .focused($isInputActive)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(height: 60)
                    
                    subTasksView()
                }
                
                groupedContent {
                    datePickerWithTitle("Start Time", date: $startTime)
                    datePickerWithTitle("End Time", date: $endTime)
                }
                
                groupedContent {
                    VStack(spacing: 0) {
                        Divider()
//                        togglableRow(systemIcon: "bell", title: "Remind Me", isOn: $isReminded)
                        
                        row(systemIcon: "bell", title: "Remind Me") {
                            Text("10 minutes before").foregroundColor(Color.secondary)
                        } trailing: {
                            Text("None").foregroundColor(Color.secondary)
                        }
                        
                        row(systemIcon: "repeat", title: "Repeat") {

                        } trailing: {
                            Text("None").foregroundColor(Color.secondary)
                        }
                        
                        row(systemIcon: "mappin.and.ellipse", title: "Location") {
                            
                        } trailing: {
                            Text("").foregroundColor(Color.secondary)
                        }

                        row(systemIcon: "tag", title: "Tag") {
                            ChooseTagView()
                        } trailing:  {
                            TagView()
                        }
                        
                    }
                    
                    TextView(text: $note, prompt: "Add note")
                        .font(.body)
                        .frame(height: 88)
                }
            }
            .padding()
            .font(.system(size: 15))
        }
        .navigationTitle("New Task")
        .padding(.bottom, 30)
        .onTapGesture {
            resignFirstResonder()
        }
    }
    
    private func row<Label: View, Destination: View>(systemIcon: String,
                                                     title: String,
                                                     @ViewBuilder destination: () -> Destination,
                                                     @ViewBuilder trailing: () -> Label) -> some View {
        
        NavigationLink(destination: destination) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: systemIcon).font(Font.system(size: 16)).frame(width: 32)
                    Text(title)
                    Spacer()
                    trailing()
                    Image(systemName: "chevron.right")
                        .font(.caption2.bold())
                        .foregroundColor(Color.secondary)
                }
                .frame(height: 50)
                Divider()
            }
        }
        .foregroundColor(Color.primary)
    }
    
    private func togglableRow(systemIcon: String, title: String, isOn: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: systemIcon).font(Font.system(size: 16)).frame(width: 32)
                Toggle(title, isOn: isOn).padding(.trailing, 4)
            }
            .frame(height: 50)
            Divider()
        }
    }
    
    private func subTasksView() -> some View {
        VStack(spacing: 0) {
            if subTasks.isEmpty {
                Button {
                    addEmptySubTask()
                } label: {
                    HStack {
                        Image(systemName: "plus").font(Font.system(size: 16))
                        Text("Add Tasks")
                    }
                    .lExpanded()
                }
                .font(.body.weight(.regular))
                .frame(height: 44)
            } else {
                ForEach($subTasks) { $task in
                    SubTaskCell($task.title, isCompleted: $task.isCompleted) {
                        deleteSubTask(task)
                    } onSubmit: {
                        addEmptySubTask()
                    }
                    .frame(height: 40)
                }
            }
        }
    }
   
    private func groupedContent<Content>(spacing: Double = 16,
                                         @ViewBuilder content: () -> Content
    ) -> some View where Content: View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
    }
    
    private func contentWithTitle<Content>(_ title: String,
                                           @ViewBuilder content: () -> Content
    ) -> some View where Content: View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.regular)
                .foregroundColor(Color.blue.opacity(0.8))
            content()
                .frame(height: 44)
        }
    }
    
    private func datePickerWithTitle(_ title: String, date: Binding<Date>) -> some View {
        contentWithTitle(title) {
            DatePicker("", selection: date,in: startTime..., displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .font(.body.weight(.medium))
        }
    }
    
    private func addEmptySubTask() {
        withAnimation {
            subTasks.append(SubTask())
        }
    }
    
    private func deleteSubTask(_ task: SubTask) {
        guard let index = subTasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        let _ = withAnimation {
            subTasks.remove(at: index)
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}

extension View {
    func resignFirstResonder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
