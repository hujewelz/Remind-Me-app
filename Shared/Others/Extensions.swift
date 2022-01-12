//
//  Extensions.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import Foundation

extension String {
    var isAbsoluteEmpty: Bool {
        absoluteText.isEmpty
    }
    
    var absoluteText: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
