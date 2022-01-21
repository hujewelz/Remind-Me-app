//
//  SearchBar.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    let onCancel: (() -> Void)?
    let onSearch: ((String) -> Void)?
    
    @FocusState private var isInputActive: Bool
    
    init(_ text: Binding<String>, onCancel: (() -> Void)? = nil, onSearch: ((String) -> Void)? = nil) {
        _text = text
        self.onCancel = onCancel
        self.onSearch = onSearch
    }

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(Color(uiColor: .systemGray))
                
                HStack(spacing: 0) {
                    TextField(Localize.search.key, text: $text)
                        .focused($isInputActive)
                        .frame(height: 32)
                        .lExpanded()
                        .submitLabel(.search)
                        .onSubmit {
                            onSearch?(text)
                        }
                    
                    clearButton.opacity(text.isAbsoluteEmpty ? 0 : 1)
                }
            }
            .padding(.leading, 8)
            .frame(height: 36)
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(8)
            
            Button(Localize.cancel.key) {
                withAnimation {
                    isInputActive = false
                }
                onCancel?()
            }
            .font(.body.bold())
        }
        .padding(.horizontal)
        .onAppear {
            isInputActive = true
        }
    }
    
    private var clearButton: some View {
        Button {
            text = ""
        } label: {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
        }
        .frame(width: 30, height: 30)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(.constant(""))
    }
}
