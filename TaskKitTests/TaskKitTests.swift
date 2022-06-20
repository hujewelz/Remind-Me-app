//
//  TaskKitTests.swift
//  TaskKitTests
//
//  Created by huluobo on 2022/1/26.
//

import XCTest
@testable import TaskKit

class TaskKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStore() throws {
        var store = TestStore(100);
        XCTAssertEqual(store.state, 100)
        
        store.dispatch(.a)
        XCTAssertEqual(store.state, 1)
        
        store.dispatch(.b)
        XCTAssertEqual(store.state, 2)
        
        store.dispatch(.c(1000))
        XCTAssertEqual(store.state, 1000)
        
    }

    
    enum MyAction: Action {
        case a, b
        case c(Int)
    }

    struct TestStore: Store {
        
        var reducer: (Int?, MyAction) -> Int
        
        var state: Int?
        
        init(_ initState: Int?) {
            state = initState
            
            reducer = { prevState, action in
                switch action {
                case .a:
                    return 1
                case .b:
                    return 2
                case .c(let val):
                    return val
                }
            }
        }
    }

}
