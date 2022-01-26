//
//  ColorPallet.swift
//  TODO
//
//  Created by huluobo on 2022/1/26.
//

import SwiftUI
import TaskKit

struct ColorPallet: View {
    @Binding var selection: Tag.TagColor
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Tag.TagColor.allCases) { color in
                    color.color
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .padding(4)
                        .background {
                            ZStack {
                                if selection == color {
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .stroke(Color.black)
                                }
                            }
                        }
                        .padding(2)
                        .onTapGesture {
                            withAnimation {
                                selection = color
                            }
                        }
                }
            }
        }
    }
}

struct ColorPallet_Previews: PreviewProvider {
    static var previews: some View {
        ColorPallet(selection: .constant(.red))
    }
}

extension Tag.TagColor: Identifiable {
    public var id: String { rawValue }
}
