//
//  DatePickView.swift
//  TODO
//
//  Created by huluobo on 2022/1/18.
//

import SwiftUI

struct DatePickView: View {
    @State private var date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                DatePicker("", selection: $date, in: Date()...)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxHeight: 400)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                            }
                        }
                        
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Done")
                            }

                        }
                    }
            }
            .navigationTitle("Date & Time")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DatePickView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickView()
    }
}
