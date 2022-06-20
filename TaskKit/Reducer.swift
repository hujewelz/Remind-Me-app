//
//  Reducer.swift
//  TaskKit
//
//  Created by luobobo on 2022/6/20.
//

import Foundation

/// Object that represent a `state`
protocol State {}

/// Object which is issued in app
protocol Action {}


public protocol Store : AnyObject {
    associatedtype StateType
    associatedtype ActionType
    
    typealias Reducer = (StateType?, ActionType) async -> StateType
    
    var reducer: Reducer { get set }
    
    var state: StateType { get set }
}

extension Store {
    public func dispatch(_ action: ActionType) async {
        state = await reducer(state, action)
    }
}

extension Int: State {}
extension Int8: State {}
extension Int16: State {}
extension Int32: State {}
extension Int64: State {}
extension Float: State {}
extension Double: State {}
extension String: State {}

