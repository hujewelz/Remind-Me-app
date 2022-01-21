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
                
                Text("Calendar app interaction build, it show hard 🤯")
                    .lineLimit(2)
                
                HStack {
                    Label("12:00 to 14:30 • 1.5 hours", systemImage: "clock.fill")
                        .font(.footnote)
                    Image(systemName: "bell.fill")
                        .font(.system(size: 8))
                }
                
                Text("Tasks • 1 of 4")
                    .font(.footnote)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Pallet.tertiary.opacity(0.1)
                    .frame(width: 28, height: 28)
                    .background()
                    .clipShape(Circle())
                    .overlay {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Pallet.iconPrimary)
                    }
                    .contextMenu {
                        Section {
                            Button("♥️ - Hearts", action: selectHearts)
                            Button("♣️ - Clubs", action: selectClubs)
                        }
                        Button("♠️ - Spades", action: selectSpades)
                        Button("♦️ - Diamonds", action: selectDiamonds)
                    }
                Spacer()
                // Tag
                Text("Meeting")
                    .font(.footnote.bold())
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
    
    func selectHearts() {}
    func selectClubs() {}
    func selectSpades() {}
    func selectDiamonds() {}
    
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell()
    }
}
