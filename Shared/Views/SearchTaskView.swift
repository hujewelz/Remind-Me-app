//
//  SearchTaskView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI
import TaskKit

struct SearchTaskView: View {
    @State private var text = ""
    @Binding var isSearchActivated: Bool
    
    @EnvironmentObject var store: TaskStore
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                SearchBar($text) {
                    isSearchActivated = false
                } onSearch: { text in
                    
                }
            }
            .frame(height: 44)
            
            TaskList(store: store, showsDataPicker: false)
        }
        .background(Pallet.systemBackground)
    }
}

struct SearchTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTaskView(isSearchActivated: .constant(true))
    }
}
