//
//  NewTaskView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI
import TaskKit


struct NewTaskView: View {

    @FocusState private var isInputActive: Bool
    
    @EnvironmentObject var store: TaskStore
    @ObservedObject var vm: NewTaskViewModel
    
    var body: some View {
        ModalView(confirmEnabled: vm.task.title.isAbsoluteEmpty) {
            Task {
                print("Create a new task: ", vm.task)
                await store.dispatch(.update(vm.task))
            }
            
        } content: {
            content
        }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                groupedContent(spacing: 8) {
                    TextEditor(text: $vm.task.title)
                        .lineLimit(2)
                        .focused($isInputActive)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxHeight: 60)
                    
                    subTasksView()
                }
                
                groupedContent {
                    datePickerWithTitle("Start Time", date: $vm.task.startAt)
                    datePickerWithTitle("End Time", date: $vm.task.endAt)
                }
                
                groupedContent {
                    VStack(spacing: 0) {
                        Divider().background(Pallet.tertiary.opacity(0.2))
                        
                        tapableRow(systemIcon: "bell", title: "Remind Me") {
                            RemindView(time: $vm.task.remind)
                        } trailing: {
                            Text(vm.task.remind != nil ? vm.task.remind!.title : "Never")
                                .foregroundColor(Color.secondary)
                        }
                        
                        tapableRow(systemIcon: "repeat", title: "Repeat") {

                        } trailing: {
                            Text("None").foregroundColor(Color.secondary)
                        }
                        
                        tapableRow(systemIcon: "mappin.and.ellipse", title: "Location") {
                            LocationView()
                        } trailing: {
                            Text("").foregroundColor(Color.secondary)
                        }

                        tapableRow(systemIcon: "tag", title: "Tag") {
                            ChooseTagView()
                        } trailing:  {
                            TagView()
                        }
                        
                    }
                    
                    TextView(text: $vm.task.content, prompt: "Add note")
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
    
    private func tapableRow<Label: View, Destination: View>(systemIcon: String,
                                                     title: String,
                                                     @ViewBuilder destination: () -> Destination,
                                                     @ViewBuilder trailing: () -> Label) -> some View {
        
        NavigationLink(destination: destination) {
            row(systemIcon: systemIcon, title: title) {
                trailing()
                Image(systemName: "chevron.right")
                    .font(.caption2.bold())
                    .foregroundColor(Color.secondary)
            }
        }
    }
    
    private func row<Label: View>(systemIcon: String,
                                  title: String,
                                  @ViewBuilder trailing: () -> Label) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: systemIcon)
                    .font(Font.system(size: 15).bold())
                    .foregroundColor(Color.primary.opacity(0.65))
                    .frame(width: 32)
                Text(title)
                Spacer()
                trailing()
            }
            .frame(height: 50)
            Divider()
                .background(Pallet.tertiary.opacity(0.2))
        }
        .foregroundColor(Color.primary.opacity(0.8))
        .background(Pallet.systemBackground)
    }
    
    private func subTasksView() -> some View {
        VStack(spacing: 0) {
            if vm.task.subTasks.isEmpty {
                Button(action: vm.addEmptySubTask) {
                    HStack {
                        Image(systemName: "plus").font(Font.system(size: 16))
                        Text("Add Tasks")
                    }
                    .lExpanded()
                }
                .font(.body.weight(.regular))
                .frame(height: 44)
            } else {
                ForEach($vm.task.subTasks) { $task in
                    SubTaskCell($task.title, isCompleted: $task.isCompleted) {
                        vm.deleteSubTask(task)
                    } onSubmit: {
                        vm.addEmptySubTask()
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
            DatePicker("", selection: date,in: vm.task.startAt..., displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .font(.body.weight(.medium))
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(vm: NewTaskViewModel(task: nil))
    }
}

extension View {
    func resignFirstResonder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
