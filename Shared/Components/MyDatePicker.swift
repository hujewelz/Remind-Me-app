//
//  MyDatePicker.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI

struct MyDatePicker: View {
    
    enum DisplayStyle {
        case week
        case month
    }
    
    let colums = Array(repeating: GridItem(.flexible()), count: 7)
    @StateObject private var store = DatePickerStore()
    
    @Namespace private var animation
    
    private func currentDateColor(_ date: Date) -> Color {
        store.isInSameDay(date) ? Color.white : Color.primary
    }
    
    var body: some View {
        LazyVGrid(columns: colums, alignment: .center, spacing: 8, pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(store.datesToShow) { date in
                    ZStack(alignment: .bottom) {
                        Text(date.day)
                            .font(.title3)
                            .fontWeight(store.isToday(date.date) ? .semibold : .regular)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                        if store.isToday(date.date) {
                            currentDayView()
                        }
                    }
                    .foregroundColor(store.isInSameDay(date.date) ? Color.white : Color.primary)
                    .background(
                        ZStack(alignment: .bottom) {
                            if store.isInSameDay(date.date) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "BGANIMATION", in: animation)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation {
                            store.currentDate = date.date
                        }
                    }
                }
            } header: {
                headerView()
            }
        }
    }
    
    private func currentDayView() -> some View {
        let colors: [Color] = [.orange, .purple, .pink]
        return HStack(spacing: 2) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color.opacity(0.4))
                    .frame(width: 3, height: 3)
                    .offset(y: -2)
            }
        }
    }
    
    private func headerView() -> some View {
        LazyVGrid(columns: colums) {
            ForEach(store.weekdays, id: \.self) { weekday in
               Text(weekday)
                    .foregroundColor(Pallet.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
}


struct MyDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        MyDatePicker()
    }
}


@MainActor
final class DatePickerStore: ObservableObject {
    
    @Published var datesToShow: [DisplayibleDate] = []
    @Published var currentDate = Date()
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init() {
        Task {
            loadDateOfCurrentMonth()
            print("current thread: ", Thread.current)
        }
    }
    
    private func loadDateOfCurrentMonth() {
        datesToShow = dateOfMonth(Date())
        loadDateOfCurrentWeek()
    }
    
    private func loadDateOfCurrentWeek() {
        let calendar = Calendar.current
        
        let currentWeek = calendar.component(.weekOfMonth, from: Date())
        
        Task {
            datesToShow = datesToShow.filter { date in
                calendar.component(.weekOfMonth, from: date.date) == currentWeek
            }
        }
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isInSameDay(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: currentDate)
    }
    
    func dateOfMonth(_ date: Date) -> [DisplayibleDate] {
        var result: [DisplayibleDate] = []
        let range = rangOfMonth(date)
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        guard let beginOfThisMonth = calendar.date(byAdding: DateComponents(day: 1 - day), to: date) else { return [] }
        
        let weekdayOfBeginOfThisMonth = calendar.component(.weekday, from: beginOfThisMonth)
        
        // date of last month in one week
        for i in stride(from: weekdayOfBeginOfThisMonth, to: 1, by: -1) {
            let tmp = calendar.date(byAdding: DateComponents(day: 1-i), to: beginOfThisMonth)
            result.append(DisplayibleDate(date: tmp ?? date, didShow: false))
        }
        
        // date of this month
        for i in range {
            if let date = calendar.date(byAdding: DateComponents(day: i-1), to: beginOfThisMonth) {
                result.append(DisplayibleDate(date: date))
            }
        }
        return result
    }
    
    func rangOfMonth(_ date: Date) -> Range<Int> {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return 0..<1 }
        return range
    }
}

struct DisplayibleDate: CustomDebugStringConvertible, Identifiable {
    let id: UUID
    let date: Date
    let didShow: Bool
    
    var day: String {
        dayDateFormatter().string(from: date)
    }
    
    init(date: Date, didShow: Bool = true) {
        id = UUID()
        self.date = date
        self.didShow = didShow
    }
    
    var debugDescription: String {
        "DisplayibleDate(date: \(date.formatted(date: .abbreviated, time: .omitted)) , showed: \(didShow))"
    }
}


func dayDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}
