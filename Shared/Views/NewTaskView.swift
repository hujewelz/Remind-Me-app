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
            VStack(alignment: .leading, spacing: 16) {
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
                    
                    contentWithTitle("Choose a Tag") {
                        chooseTag()
                    }
                }
                
                groupedContent {
                    VStack(spacing: 0) {
                        Divider()
                        togglableRow(systemIcon: "bell", title: "Remind Me", isOn: $isReminded)
                        togglableRow(systemIcon: "repeat", title: "Repeat", isOn: $isRepeated)
                        togglableRow(systemIcon: "location", title: "Location", isOn: $enableLocation)
                    }
                    
                    TextView(text: $note, prompt: "Add note")
                        .font(.body)
                        .frame(height: 88)
                }
            }
            .padding()
            .font(.system(size: 15))
        }
        .onTapGesture {
            resignFirstResonder()
        }
    }
    
    private func togglableRow(systemIcon: String, title: String, isOn: Binding<Bool>) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: systemIcon).font(Font.system(size: 16))
                Toggle(title, isOn: isOn).padding(.trailing, 4)
            }
            .frame(height: 56)
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
    
    private func chooseTag() -> some View {
        HStack(spacing: 20) {
            TagView()
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(Font.system(size: 16))
            }
            .padding(8)
            .background {
                Circle()
                    .strokeBorder(Pallet.angluarGradient, lineWidth: 1)
            }
        }
        .sheet(isPresented: $isPresented) {
            ChooseTagView()
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
        VStack(alignment: .leading) {
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
