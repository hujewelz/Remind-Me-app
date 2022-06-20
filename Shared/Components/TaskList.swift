//
//  TaskList.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI
import TaskKit

struct TaskList: View {
    
    let showsDataPicker: Bool
    @State private var date = Date()
    
    @EnvironmentObject var store: TaskStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 8) {
                if showsDataPicker {
                    CustomDatePicker($date)
                }
                LazyVStack(spacing: 12) {
                    ForEach(store.state) { task in
                        TaskCell(task: task)
                    }
                    .padding(.horizontal)
                }
                .background(Pallet.systemBackground)
                .padding(.top)
            }
        }
        .task {
            await store.dispatch(.fetch(date))
            
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList(showsDataPicker: true)
    }
}
