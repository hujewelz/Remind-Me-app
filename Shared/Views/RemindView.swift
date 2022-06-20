//
//  RemindView.swift
//  TODO
//
//  Created by luobobo on 2022/6/20.
//

import SwiftUI

struct RemindView: View {
    
    @Binding var time: Times?
    
    @Environment(\.dismiss) private var dismiss;
    
    let times: [Times] = [
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
    
    private func cell(_ time: Times?) -> some View {
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
        .background(Pallet.systemBackground)
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

enum Times {
    case atTime
    case custom(Int)
    
    init(minutes: Int) {
        assert(minutes >= 0)
        if minutes == 0 {
            self = .atTime
        } else {
            self = .custom(minutes)
        }
    }
    
    var title: String {
        switch self {
        case .atTime:
            return "At time of task"
        case .custom(let minutes):
            if minutes < 60 {
                return "\(minutes) minutes before"
            } else {
                let hour = minutes / 60
                return "\(hour) \(hour > 1 ? "hours" : "hour") before"
            }
            
        }
    }
    
    var minutes: Int {
        switch self {
        case .atTime:
            return 0
        case .custom(let int):
            return int
        }
    }
}

extension Times: Hashable, Identifiable {
    var id: Int { minutes }
}
