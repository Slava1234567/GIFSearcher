//
//  NewUnitTest.swift
//  GIFSearchTests
//
//  Created by Slava on 9/3/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import XCTest
@testable import GIFSearch

class NewUnitTest: XCTestCase {
    
    var parseJSON: ParseJSON?
    
    override func setUp() {
        super.setUp()
        
        self.parseJSON = ParseJSON()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func checkCountArrayData () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        XCTAssertTrue(array?.count != 0)
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
