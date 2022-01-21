//
//  TaskList.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct TaskList: View {
    
    let showsDataPicker: Bool
    @State private var date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                if showsDataPicker {
                    MyDatePicker($date)
                }
                LazyVStack(spacing: 12) {
                    ForEach((0...6), id: \.self) { _ in
                        TaskCell()
                    }
                    .padding(.horizontal)
                }
                .background(Pallet.systemBackground)
                .padding(.top)
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList(showsDataPicker: true)
    }
}
