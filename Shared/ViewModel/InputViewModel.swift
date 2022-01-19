//
//  InputViewModel.swift
//  TODO
//
//  Created by huluobo on 2022/1/19.
//

import SwiftUI

typealias InputViewModel = InputView.ViewModel

extension InputView {
    class ViewModel: ObservableObject {

        @Published var text: String = ""
        @Published var pickedDate: Date?
        @Published var isReminded: Bool = false
        @Published var showsDatePicker = false
        @Published var showsDateToPicker = false
        
        var todo: Todo? {
            didSet {
                text = todo?.title ?? ""
                pickedDate = todo?.dueDate
                isReminded = todo?.isRemind ?? false
            }
        }
        
        init() {
            print("created")
        }
    }
}

extension InputViewModel {
    enum DateToChoose: String, CaseIterable {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case nextWeek = "Next Week"
        
        var date: Date {
            let dueDateNow = Date(timeInterval: 30 * 60, since: Date())
            switch self {
            case .today:
                return dueDateNow
            case .tomorrow:
                return Date(timeInterval: 24 * 3600, since: dueDateNow)
            case .nextWeek:
                let calendar = Calendar.current
                let currentWeekDay = calendar.component(.weekday, from: dueDateNow) - 1
                return calendar.date(byAdding: DateComponents(day: 8 - currentWeekDay), to: dueDateNow)
                    ?? Date(timeInterval: Double(8 - currentWeekDay) * 24 * 3600, since: dueDateNow)
            }
        }
    }
    
    func pickDate(_ chooseItem: DateToChoose) {
        showsDateToPicker = false
        pickedDate = chooseItem.date
    }
    
    func pickDate(_ date: Date) {
        pickedDate = date
    }
   
    func submit() {
        var todo = self.todo ?? Todo(title: text)
        todo.title = text
        todo.dueDate = pickedDate
        todo.isRemind = isReminded
        self.todo = todo
    }
    
    func reset() {
        text = ""
        showsDatePicker = false
        showsDateToPicker = false
        pickedDate = nil
        todo = nil
    }
}

extension Date {
    var dateStr: String {
        let calendar = Calendar.current
        let now = Date()
        let currentWeekDay = calendar.component(.weekday, from: now)
        let weekDay = calendar.component(.weekday, from: self)
        
        if currentWeekDay == weekDay {
            return "Today"
        } else if weekDay - currentWeekDay == 1 {
            return "Tomorrow"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        return dateFormatter.string(from: self)
    }
}
