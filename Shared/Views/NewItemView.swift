//
//  NewItemView.swift
//  TODO
//
//  Created by huluobo on 2022/1/11.
//

import SwiftUI

struct NewItemView: View {
    @State private var text = ""
    var body: some View {
        HStack {
            TextField("Do what you want...", text: $text)
                .font(.subheadline.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white)
                .onSubmit {
                    print("submint: ", text)
                }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Color.white)
            
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView()
    }
}
