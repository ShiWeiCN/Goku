//
//  GokuTests.swift
//  GokuTests
//
//  Created by shiwei on 10/01/2017.
//  Copyright © 2017 shiwei. All rights reserved.
//

import XCTest
@testable import Goku

class GokuTests: XCTestCase {
    
    var vc = UIViewController()
    
    override func setUp() {
        super.setUp()
        vc.goku.presentAlert(animated: true) { (make) in
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
