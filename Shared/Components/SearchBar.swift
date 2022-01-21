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
                
                TextField(Localize.search.key, text: $text)
                    .focused($isInputActive)
                    .frame(height: 32)
                    .lExpanded()
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch?(text)
                    }
            }
            .padding(.horizontal, 8)
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
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(.constant(""))
    }
}
