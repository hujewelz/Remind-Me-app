//
//  InputToolBar.swift
//  TODO
//
//  Created by huluobo on 2022/1/18.
//

import SwiftUI

struct InputToolBar: View {
    
    
    @State private var showsDatePicker = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 16) {
                Button {
                    
                } label: {
                    Image(systemName: "bell")
                }.padding(.leading)
                
                if pickedDate == nil {
                    Button {
                        showsDatePicker.toggle()
                    } label: {
                        Image(systemName: "calendar.badge.clock")
                    }
                } else {
                    datePickedView
                }
            }
            .frame(height: 44)
            .background(Pallet.systemBackground)
            .zIndex(2)
            
            dateView
                .zIndex(0)
                .offset(x: dateViewOffset)
                .animation(.interpolatingSpring(mass: 1, stiffness: 150, damping: 18, initialVelocity: 1), value: dateViewOffset)
        }
        .tint(Pallet.iconPrimary)
        .font(.title3.weight(.bold))
        .frame(height: 44)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Pallet.systemBackground)
        
    }
    
    private var dateToPick: [String] {
        ["Today", "Tomorrow", "Next Week", "+"]
    }
    
    private var dateViewOffset: CGFloat {
        showsDatePicker ? 84 : -300
    }
    
    @State private var pickedDate: String?
    
    private var dateView: some View {
        HStack(alignment:.center, spacing: 10) {
            ForEach(dateToPick, id: \.self) { date in
                Button(action: {
                    pickedDate = date
                    showsDatePicker = false
                }, label: {
                    Text(date)
                        .font(.callout)
                        .fontWeight(.bold)
                })
                    
            }
        }
        .padding(.horizontal)
        .frame(height: 32)
        .foregroundColor(Pallet.iconPrimary)
        .background(Pallet.gradientStart)
        .clipShape(Capsule())
    }
    
    private var datePickedView: some View {
        HStack(alignment: .center) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
            Text("Due \(pickedDate!)")
            Button {
                pickedDate = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }

        }
        .font(.callout.bold())
        .padding(.horizontal)
        .frame(height: 32)
        .foregroundColor(.white)
        .background(Color.purple)
        .clipShape(Capsule())
    }
}

struct DatePickButton_Previews: PreviewProvider {
    static var previews: some View {
        InputToolBar()
            
    }
}
