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
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        ModalView(confirmEnabled: true) {
            dismiss()
        } content: {
            TextEditor(text: $text)
                .padding(.horizontal)
                .focused($isInputActive)
        }
        .onAppear {
            isInputActive = true
        }

    }
}

struct TaskNoteView_Previews: PreviewProvider {
    static var previews: some View {
        TaskNoteView(text: .constant("the is a new task"))
    }
}
