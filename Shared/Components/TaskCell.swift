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
//        .background(Pallet.secondary)
        .background(color.opacity(0.1))
        .cornerRadius(12)
//        .mySwipeAction()
        
    }
    
    func selectHearts() {}
    func selectClubs() {}
    func selectSpades() {}
    func selectDiamonds() {}
    
}

struct SwipeViewModifier: ViewModifier {
    @State private var offsetX = 0.0
    @State private var prevOffsetX = 0.0
    
    let width = 200.0
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                Spacer()
                Color.red.frame(width: width, height: 40)
            }
            content
                .offset(x: offsetX)
        }
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onChanged { value in
                if value.translation.width < 0 {
                    offsetX = max(-width, value.translation.width)
                } else {
                    var x = offsetX
                    x += value.translation.width
                    offsetX = min(0, x)
                }
                
            } .onEnded { value in
                print("tranlate end: ", value.translation.width, ", time: ",value.time)
                var x =  min(0, value.translation.width)
                x = value.translation.width <= -(width * 0.4) ? -width : 0
                withAnimation {
                    offsetX = x
                }
                
            }
        )
    }
}

extension View {
    func mySwipeAction() -> some View {
        modifier(SwipeViewModifier())
    }
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
