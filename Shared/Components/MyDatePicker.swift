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
        LazyVGrid(columns: colums, pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(store.datesToShow) { date in
                    ZStack {
                        Text(date.day)
                            .font(.system(size: 16))
                            .fontWeight(store.isToday(date.date) ? .semibold : .regular)
                            .opacity(date.didShow ? 1 : 0)
                        if store.isToday(date.date) {
                            currentDayView()
                                .offset(y: 14)
                        }
                    }
                    .frame(width: 32, height: 36)
                    .foregroundColor(store.isInSameDay(date.date) ? Color.white : Color.primary)
                    .background(
                        ZStack(alignment: .bottom) {
                            if store.isInSameDay(date.date) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.pink)
                                    .matchedGeometryEffect(id: "BGANIMATION", in: animation)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if store.isInSameDay(date.date) {
                                store.changeDisplayStyle()
                            } else {
                                store.currentDate = date.date
                            }
                        }
                    }
                }
            } header: {
                weekDayHeader()
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(Pallet.systemBackground)
    }
    
    private func currentDayView() -> some View {
        let colors: [Color] = [.orange, .red, .purple]
        return HStack(spacing: 2) {
            ForEach(colors.indices, id: \.self) { i in
                Circle()
                    .fill(colors[i].opacity(0.6))
                    .frame(width: i == 1 ? 5 : 4, height: i == 1 ? 5 : 4)
            }
        }
    }
    
    private func weekDayHeader() -> some View {
        LazyVGrid(columns: colums) {
            ForEach(store.weekdays, id: \.self) { weekday in
               Text(weekday)
                    .font(.system(size: 15))
                    .foregroundColor(Pallet.secondary)
            }
        }
        .padding(.vertical, 8)
        .background(Pallet.systemBackground)
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
    
    var displayStyle = MyDatePicker.DisplayStyle.week
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    init() {
       loadDateOfCurrentWeek()
    }
    
    func changeDisplayStyle() {
        switch displayStyle {
        case .month:
            displayStyle = .week
            loadDateOfCurrentWeek()
        case .week:
            displayStyle = .month
            loadDateOfCurrentMonth()
        }
    }
    
    private func loadDateOfCurrentMonth() {
        let dates = dateOfMonth(Date())
//        withAnimation {
            datesToShow = dates
//        }
    }
    
    private func loadDateOfCurrentWeek() {
        let calendar = Calendar.current
        
        let now = currentDate
        let currentMonth = calendar.component(.month, from: now)
        guard let beginOfWeek = calendar.dateInterval(of: .weekOfMonth, for: now)?.start else { return }
        
        let dates = (0..<7).compactMap { i -> DisplayibleDate? in
            if let date = calendar.date(byAdding: .day, value: i, to: beginOfWeek) {
                let month = calendar.component(.month, from: date)
                return DisplayibleDate(date: date, didShow: month == currentMonth)
            }
            return nil
        }
//        withAnimation {
            datesToShow = dates
//        }
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
