//
//  InputToolBarViewModel.swift
//  TODO
//
//  Created by huluobo on 2022/1/18.
//

import SwiftUI

typealias InputToolBarVM = InputToolBar.ViewModel

extension InputToolBar {
    
    class ViewModel: ObservableObject {
        @Published var showsDatePicker = false
        @Published var pickedDate: DateToChoose?
        
    
        enum DateToChoose: String, CaseIterable {
            case today = "Today"
            case tomorrow = "Tomorrow"
            case nextWeek = "Next Week"
        }
    }
}

extension InputToolBar.ViewModel {
    func reset() {
        showsDatePicker = false
        pickedDate = nil
    }
}
