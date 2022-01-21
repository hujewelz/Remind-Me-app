//
//  ModalView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct ModalView<Content>: View where Content: View {
    let content: Content
    
    @Environment(\.dismiss) private var dismiss
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .bold()
                        }
//                        .disabled(text.isAbsoluteEmpty)
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
        ModalView {
            Text("Content")
                .tExpanded()
        }
    }
}
