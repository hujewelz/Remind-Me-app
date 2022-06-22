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
       SimpleList(data: times, selected: $time)
    }
}

struct RepeatView: View {
   
    @Binding var `repeat`: TKTask.Repeat?
    
    var body: some View {
        SimpleList(data: TKTask.Repeat.allCases, selected: $repeat)
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        RemindView(time: .constant(nil))
        RepeatView(repeat: .constant(.week))
    }
}

extension TKTask.Remind: Hashable {
    
    public static func == (lhs: TKTask.Remind, rhs: TKTask.Remind) -> Bool {
        lhs.minutes == rhs.minutes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minutes)
    }
}

extension TKTask.Remind: SimpleListDisplayTitle {}

extension TKTask.Repeat: SimpleListDisplayTitle {
    var title: String {
        switch self {
        case .day:
            return "Every Day"
        case .week:
            return "Every Week"
        case .month:
            return "Every Month"
        case .year:
            return "Every Year"
        }
    }
}
