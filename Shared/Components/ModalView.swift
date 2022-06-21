//
//  ModalView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct ModalView<Content>: View where Content: View {
    let confirmEnabled: Bool
    let content: Content
    let confirm: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(confirmEnabled: Bool, confirm: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.confirmEnabled = confirmEnabled
        self.confirm = confirm
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            confirm()
                            dismiss()
                        } label: {
                            Text("Done")
                                .bold()
                        }
                        .disabled(confirmEnabled)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
        
        .navigationViewStyle(.stack)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(confirmEnabled: true) {
            
        } content: {
            Text("Content")
                .tExpanded()
        }
    }
}
