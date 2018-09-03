//
//  GIFSearchTests.swift
//  GIFSearchTests
//
//  Created by Viachaslau Shyla on 22.08.2018.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import XCTest
@testable import GIFSearch

class GIFSearchTests: XCTestCase {
    
    var viewModel: ViewModel?
    var parseJSON: ParseJSON?
    
    override func setUp() {
        super.setUp()
        
        self.viewModel = ViewModel()
        self.parseJSON = ParseJSON()
    }
    
    
    func checkCountArrayData () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        XCTAssertTrue(array?.count != 0)
    }
    
    func checkCaseRaiting () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        
        for dict in array! {
            let value = dict["rating"]
            XCTAssertTrue(value != nil)
        }
    }
    
    func checkCaseImport_datetime () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        
        for dict in array! {
            let value = dict["import_datetime"]
            XCTAssertTrue(value != nil)
        }
    }
    
    func checkCaseTrending_datetime () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        
        for dict in array! {
            let value = dict["trending_datetime"]
            XCTAssertTrue(value != nil)
        }
    }
    
    func checkCasePreview_gif () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        
        for dict in array! {
            let value = dict["preview_gif"]
            XCTAssertTrue(value != nil)
        }
    }
    func checkCaseOriginal () {
        let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
        let array = self.parseJSON?.arrayData
        self.parseJSON?.pasreWithUrl(urlName: trandigUrl, complition: { (array) in
        })
        
        for dict in array! {
            let value = dict["original"]
            XCTAssertTrue(value != nil)
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
