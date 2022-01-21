//
//  SharedDataFormatter.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import Foundation

struct SharedDateFormatter {
    static let shared = SharedDateFormatter()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
    }
    
    static var dayDateFormatter: DateFormatter {
        shared.dateFormatter.dateFormat = "d"
        return shared.dateFormatter
    }
}
