//
//  Const.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import Foundation

enum Const {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

}
