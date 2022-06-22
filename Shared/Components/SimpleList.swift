//
//  SimpleList.swift
//  TODO (iOS)
//
//  Created by luobobo on 2022/6/22.
//

import SwiftUI


protocol SimpleListDisplayTitle: Hashable {
    var title: String { get }
}



struct SimpleList<Data>: View where Data: RandomAccessCollection, Data.Element: SimpleListDisplayTitle {

    var data: Data
    @Binding var selected: Data.Element?
    
    @Environment(\.dismiss) private var dismiss;
    
    var body: some View {
        List {
            Section {
                cell(nil)
            }
           
            ForEach(data, id: \.self) { time in
                cell(time)
            }
            
        }
    }
    
    private func cell(_ ele: Data.Element?) -> some View {
        HStack {
            Text(ele == nil ? "None" : ele!.title).padding(.vertical, 6)
            Spacer()
            if selected == ele {
                Image(systemName: "checkmark")
                    .font(.footnote.bold())
                    .foregroundColor(Pallet.primary)
            }
        }
        .lExpanded()
        .onTapGesture {
            selected = ele
            dismiss()
        }
    }
}
