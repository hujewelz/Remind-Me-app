//
//  Calendar+Extensions.swift
//  TODO
//
//  Created by luobobo on 2022/1/23.
//

import Foundation

extension Calendar {
    /// Get the date of month whith current time
    /// - Parameter month: 0 if current month, -1 is last month, 1 is next month
    func dateNow(of month: Int) -> Date? {
        return self.date(byAdding: .month, value: month, to: Date())
    }
    
    func allDates(of month: Int) -> [Date] {
        guard let dateAtMonth = dateNow(of: month) else { return []}
        return allDates(of: dateAtMonth)
    }
    
    private func allDates(of date: Date) -> [Date] {
        // getting start date
        guard let startDate = self.date(from: dateComponents([.year, .month], from: date)),
              let range = range(of: .day, in: .month, for: startDate) else { return [] }
        return range.compactMap { self.date(byAdding: .day, value: $0 - 1, to: startDate) }
    }
}
