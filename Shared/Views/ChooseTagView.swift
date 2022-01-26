//
//  ChooseTagView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI
import TaskKit

struct ChooseTagView: View {
    private let columns = [GridItem(.adaptive(minimum: 100))]
    
    @State private var text = ""
    @State private var color = Tag.TagColor.allCases[0]
    
    var body: some View {
        ModalView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    addNewTagView()
                    ColorPallet(selection: $color)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0...7, id: \.self) { _ in
                            TagView()
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func addNewTagView() -> some View {
        HStack {
            TextField("Tag Name", text: $text)
                .frame(height: 40)
                .padding(.horizontal)
                .background(Color.secondary.opacity(0.1))
                .clipShape(Capsule())
            
            Button("Add") {
                
            }
            .padding()
        }
    }
}

struct ChooseTagView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTagView()
    }
}
