//
//  TaskCell.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI

struct TaskCell: View {
    var colors: [Color] = [.blue, .green, .pink, .cyan, .mint, .white, .gray]
    
    var color: Color {
        colors[Int.random(in: 0...6)]
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Weekly Scrun Meeting")
                    .font(.title3)
                    .foregroundColor(Color.primary)
                
                Text("Calendar app interaction build")
                    .lineLimit(2)
                
                Label("12:00 to 14:30 1.5 hours", systemImage: "clock.fill")
                    .font(.footnote)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Button {
                    
                } label: {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Pallet.iconPrimary)
                    }
                    .frame(width: 28, height: 28)
                    .background(Pallet.tertiary.opacity(0.1))
                    .clipShape(Circle())
                }
                
                // Tag
                Text("Meeting")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.15))
                    .clipShape(Capsule())
                
            }
            
        }
        .foregroundColor(Pallet.secondary)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell()
    }
}
