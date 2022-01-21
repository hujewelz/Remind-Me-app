//
//  NewTaskView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct NewTaskView: View {
    @State private var title = "Weekly Scrnm Meeting plan you day"
    @State private var startTime = Date()
    @State private var endTime = Date().advanced(by: 3600)
    @State private var isRepeated = false
    @State private var enableLocation = false
    @FocusState private var isInputActive: Bool
    
    @State private var subTasks: [SubTask] = []
    
    
    var body: some View {
        ModalView {
            content
        }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                contentWithTitle("Title") {
                    TextEditor(text: $title)
                        .focused($isInputActive)
                        .font(.system(size: 24))
                        .frame(height: 80)
                }
                
                subTasksView()
                
                HStack(spacing: 60) {
                    datePickerWithTitle("Start Time", date: $startTime)
                    
                    datePickerWithTitle("End Time", date: $endTime)
                }
                
                contentWithTitle("Choose a Tag") {
                    chooseTag()
                }
                
                VStack {
                    Divider()
                    Toggle("Repeat", isOn: $isRepeated)
                        .padding(.trailing, 4)
                    Divider()
                
                    Toggle("Location", isOn: $enableLocation)
                        .padding(.trailing, 4)
                    Divider()
                }
            }
            .padding()
            .font(.system(size: 16, weight: .medium))
        }
        
        .onTapGesture {
            resignFirstResonder()
        }
    }
    
    private func subTasksView() -> some View {
        contentWithTitle("Steps") {
            if subTasks.isEmpty {
                Button {
                    addEmptySubTask()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Steps")
                    }
                }
                .font(.body.weight(.regular))
                .frame(height: 44)
                .lExpanded()
            } else {
                ForEach($subTasks) { $task in
                    SubTaskCell($task.title, isCompleted: $task.isCompleted) {
                        deleteSubTask(task)
                    } onSubmit: {
                        addEmptySubTask()
                    }
                }
            }
        }
    }
    
    private func chooseTag() -> some View {
        HStack(spacing: 20) {
            Text("Meeting")
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .clipShape(Capsule())
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .imageScale(.medium)
            }
            .padding(8)
            .background {
                Circle()
                    .stroke(Color.secondary, lineWidth: 1)
            }
        }
    }
    
    private func contentWithTitle<Content>(_ title: String, @ViewBuilder content: () -> Content) -> some View where Content: View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.regular)
                .foregroundColor(Color.blue.opacity(0.8))
            content()
        }
    }
    
    private func datePickerWithTitle(_ title: String, date: Binding<Date>) -> some View {
        contentWithTitle(title) {
            DatePicker("", selection: date, displayedComponents: [.hourAndMinute])
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
        
        withAnimation {
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
