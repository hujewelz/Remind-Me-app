//
//  FirebaseStore.swift
//  FirebaseStore
//
//  Created by luobobo on 2022/1/23.
//

import Foundation
import SwiftUI
import Firebase

public final class FirebaseStore: ObservableObject {
    public init() {}
    
    public func setup() {
        FirebaseApp.configure()
    }
}
