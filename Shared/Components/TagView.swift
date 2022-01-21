//
//  TagView.swift
//  TODO
//
//  Created by huluobo on 2022/1/21.
//

import SwiftUI

struct TagView: View {
    
    var body: some View {
        Text("Meeting")
            .font(.system(size: 15, weight: .medium))
            .lineLimit(1)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.orange.opacity(0.1))
            .clipShape(Capsule())
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
