//
//  TaskNoteView.swift
//  TODO (iOS)
//
//  Created by luobobo on 2022/6/22.
//

import SwiftUI

struct TaskNoteView: View {
    @Binding var text: String
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: FocusField?
    
    
    enum FocusField: Hashable {
        case field
    }
    
    var body: some View {
        ModalView(confirmEnabled: true) {
            dismiss()
        } content: {
            TextEditor(text: $text)
                .padding(.horizontal)
                .focused($focusedField, equals: .field)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusedField = .field
                    }
                }
        }
    }
}

struct TaskNoteView_Previews: PreviewProvider {
    static var previews: some View {
        TaskNoteView(text: .constant("the is a new task"))
    }
}
