//
//  Home.swift
//  TODO
//
//  Created by huluobo on 2022/1/20.
//

import SwiftUI

struct Home: View {
    @State private var date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .center, spacing: 8, pinnedViews: [.sectionHeaders]) {
                Section {
                    MyDatePicker()
                        .padding(.horizontal)
                } header: {
                    headerView()
                }
                .padding(.bottom)
                list()
            }
        }
    }
   
    private func list() -> some View {
        ForEach((0...6), id: \.self) { _ in
            TaskCell()
                .padding(.horizontal)
        }
    }
    
    private func headerView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.largeTitle)
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(Pallet.secondary)
            }
            Spacer()
            // Navigation bar
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                .padding(8)
                
                Button {
                    
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
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Pallet.systemBackground)
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
