//
//  AHSClubXTests.swift
//  AHSClubXTests
//
//  Created by Anju Bhuwania on 11/17/20.
//

import XCTest
@testable import AHSClubX

class AHSClubXTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    //MARK: Event Class Tests
     // Confirm that Event init returns Event object when passed valid parameters
    func testEventInitializationSucceeds() {
        let event1 = Event.init(name: "pizza", club: "Dominoes", link: nil, type: 1)
         XCTAssertNotNil(event1)
    }
    
    func testEventInitializationFails() {
        let event2 = Event.init(name: "", club: "Dominoes", link: nil, type: 1)
         XCTAssertNil(event2)
        
        let event3 = Event.init(name: "", club: "Dominoes", link: nil, type: 0)
         XCTAssertNil(event3)
        
    }
}
