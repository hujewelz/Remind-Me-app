//
//  TaskCell.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI
import TaskKit

struct TaskCell: View {
    var colors: [Color] = [.blue, .green, .pink, .cyan, .mint, .white, .gray]
    
    var color: Color {
        colors[Int.random(in: 0...6)]
    }
    
    let task: TKTask
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.title3)
                    .foregroundColor(Color.primary)
                
                if !task.content.isAbsoluteEmpty {
                    Text(task.content)
                        .lineLimit(2)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 9))
                        Text("\(task.startTime) to \(task.endTime) • \(task.duration)")
                            .font(.footnote)
                    }
                    if task.isRemind {
                        Image(systemName: "bell.fill").font(.system(size: 8))
                    }
                }
                if !task.subTasks.isEmpty {
                    Text("Tasks • \(task.countOfFinishedSubTasks)/\(task.subTasks.count)")
                        .font(.footnote)
                }
                
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
//
//extension TKTask {
//    var startTime: String {
//        startAt.formatted(date: .omitted, time: .shortened)
//    }
//
//    var endTime: String {
//        endAt.formatted(date: .omitted, time: .shortened)
//    }
//}

//struct TaskCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCell()
//    }
//}
