//
//  RemindView.swift
//  TODO
//
//  Created by luobobo on 2022/6/20.
//

import SwiftUI
import TaskKit

struct RemindView: View {
    
    @Binding var time: TKTask.Remind?
    
    @Environment(\.dismiss) private var dismiss;
    
    let times: [TKTask.Remind] = [
        .atTime,
        .custom(5),
        .custom(10),
        .custom(15),
        .custom(30),
        .custom(60),
        .custom(120),
    ]
    
    var body: some View {
        List {
            Section {
                cell(nil)
            }
           
            ForEach(times, id: \.self) { time in
                cell(time)
            }
            
        }
    }
    
    private func cell(_ time: TKTask.Remind?) -> some View {
        HStack {
            Text(time == nil ? "None" : time!.title).padding(.vertical, 6)
            Spacer()
            if self.time == time {
                Image(systemName: "checkmark")
                    .font(.footnote.bold())
                    .foregroundColor(Pallet.primary)
            }
        }
        .lExpanded()
        .onTapGesture {
            self.time = time
            dismiss()
        }
            
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        RemindView(time: .constant(nil))
    }
}


extension TKTask.Remind: Hashable, Identifiable {
    public var id: Int { minutes }
    
    public static func == (lhs: TKTask.Remind, rhs: TKTask.Remind) -> Bool {
        lhs.minutes == rhs.minutes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minutes)
    }
}
