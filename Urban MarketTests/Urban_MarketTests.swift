//
//  Urban_MarketTests.swift
//  Urban MarketTests
//
//  Created by Mauro Arantes on 19/10/2023.
//

import XCTest
@testable import Urban_Market

class Urban_MarketTests: XCTestCase {
    
    var sut: HomeScreenViewModel?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testApiCall_isSuccess() {
        //given
        sut = HomeScreenViewModel(apiService: MockAPIService(fileName: "MockResponse"))
        //when
        sut?.apiCall()
        //then
        XCTAssertEqual(sut?.products.count, 194)
    }
    
    func testApiCall_isFailure() {
        let expetation = XCTestExpectation(description: "Fetching Products list")
        let waitDuration = 3.0
        sut = HomeScreenViewModel(apiService: MockAPIService(fileName: "Error"))
        sut?.apiCall()
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){
            XCTAssertEqual(self.sut?.products.count, 0)
            XCTAssertEqual(self.sut?.customError, NetworkError.dataNotFound)
            expetation.fulfill()
        }
        wait(for: [expetation], timeout: waitDuration)
    }
}
