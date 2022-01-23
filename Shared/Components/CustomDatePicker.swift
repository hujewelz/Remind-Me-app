//
//  CustomDatePicker.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI

struct CustomDatePicker: View {
    
    enum DisplayStyle {
        case week
        case month
    }
    
    @Binding var selection: Date
    
    private let colums = Array(repeating: GridItem(.flexible()), count: 7)
    @StateObject private var store = DatePickerStore()
    
    @Namespace private var animation
    
    init(_ selection: Binding<Date>) {
        _selection = selection
    }
    
    private func currentDateColor(_ date: Date) -> Color {
        store.isInSameDay(date) ? Color.white : Color.primary
    }
    
    var body: some View {
        LazyVGrid(columns: colums, pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(store.datesToShow) { date in
                    ZStack {
                        Text("\(date.day)")
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
                        withAnimation(.default) {
                            if store.isInSameDay(date.date) {
                                store.changeDisplayStyle()
                            } else {
                                store.currentDate = date.date
                                selection = date.date
                            }
                        }
                    }
                }
            } header: {
                weekDayHeader()
            }
        }
        .padding(.horizontal)
        .background(Pallet.systemBackground)
        .onAppear {
            store.loadData(selection)
        }
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
        CustomDatePicker(.constant(Date().advanced(by: 24 * 3600)))
    }
}

@MainActor
final class DatePickerStore: ObservableObject {
    
    @Published var datesToShow: [DisplayibleDate] = []
    @Published var currentDate = Date()
    @Published var currentMonth = 0 {
        didSet {
            if currentMonth != oldValue {
                loadDateOfCurrentMonth(shouldUpdateCache: true)
            }
        }
    }
    
    var displayStyle = CustomDatePicker.DisplayStyle.week
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    func loadData(_ date: Date) {
        currentDate = date
        loadDateOfCurrentWeek()
    }
    
    func changeDisplayStyle() {
        switch displayStyle {
        case .month:
            loadDateOfCurrentWeek()
            displayStyle = .week
        case .week:
            loadDateOfCurrentMonth()
            displayStyle = .month
        }
    }
    
    private var cachedDatesOfMonth: [DisplayibleDate]!
    private func loadDateOfCurrentMonth(shouldUpdateCache: Bool = false) {
        // if `currentMonth` is never changed, we don't need to load dates every time
        if cachedDatesOfMonth == nil || shouldUpdateCache {
            cachedDatesOfMonth = dateOfMonth(currentMonth)
        }
        // Update `id` to render every Day element to fix animation. this isn't necessary if no animation
        datesToShow = cachedDatesOfMonth.map { $0.updated(withId: UUID()) }
    }
    

    private func loadDateOfCurrentWeek() {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        guard let beginOfWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start else { return }
        
        datesToShow = (0..<7).compactMap { i -> DisplayibleDate? in
            if let date = calendar.date(byAdding: .day, value: i, to: beginOfWeek) {
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                return DisplayibleDate(date: date, day: day, didShow: month == currentMonth)
            }
            return nil
        }
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isInSameDay(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: currentDate)
    }
    
    func dateOfMonth(_ month: Int) -> [DisplayibleDate] {
        let calendar = Calendar.current
        var dateValues = calendar.allDates(of: month).compactMap { date -> DisplayibleDate in
            let day = calendar.component(.day, from: date)
            return DisplayibleDate(date: date, day: day)
        }
        if let firstDay = dateValues.first?.date {
            let weekday = calendar.component(.weekday, from: firstDay)
            for i in 1..<weekday {
                if let date = calendar.date(byAdding: .day, value: -i, to: firstDay) {
                    let day = calendar.component(.day, from: date)
                    dateValues.insert(DisplayibleDate(date: date, day: day, didShow: false), at: 0)
                }
            }
        }
        
        return dateValues
    }
    
    func rangOfMonth(_ date: Date) -> Range<Int> {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return 0..<1 }
        return range
    }
}

struct DisplayibleDate: CustomDebugStringConvertible, Identifiable {
    let id: UUID
    let date: Date
    let day: Int
    let didShow: Bool
    
    init(id: UUID, date: Date, day: Int, didShow: Bool = true) {
        self.id = id
        self.date = date
        self.day = day
        self.didShow = didShow
    }
    
    init(date: Date, day: Int, didShow: Bool = true) {
        self.init(id: UUID(), date: date, day: day, didShow: didShow)
    }
    
    var debugDescription: String {
        "DisplayibleDate(id: \(id), date: \(date.formatted(date: .abbreviated, time: .omitted)) , showed: \(didShow))"
    }
    
    func updated(withId id: UUID) -> DisplayibleDate {
        DisplayibleDate(id: id, date: date, day: day, didShow: didShow)
    }
}

