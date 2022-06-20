//
//  Home.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI

struct Home: View {
    @State private var isSearch = false
    @State private var isNewTask = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView()
            TaskList(showsDataPicker: true)
        }
        .background(Pallet.systemBackground)
        .overlay {
            if isSearch {
                SearchTaskView(isSearchActivated: $isSearch)
            }
        }
        .sheet(isPresented: $isNewTask) {
            NewTaskView()
        }
    }

    private func headerView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today")
                    .font(.largeTitle)
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(Pallet.secondary)
            }
            Spacer()
            // Navigation bar
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        isSearch = true
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                .padding(8)
                
                Button {
                    // TODO:
                } label: {
                    Image(systemName: "chart.pie")
                        .font(.title2)
                }
                .padding(8)
                .padding(.trailing, 4)
                
                Button {
                    isNewTask.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                }
                .padding(8)
                .background(Pallet.tertiary.opacity(0.1))
                .clipShape(Circle())
            }
            .frame(height: 44)
        }
        .padding([.horizontal, .bottom])
        .background(Pallet.systemBackground)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
