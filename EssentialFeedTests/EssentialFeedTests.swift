//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by mustafa salah eldin on 8/22/21.
//

import XCTest

class EssentialFeedTests: XCTestCase {
    
    // testing that creation of the object not loading any data
    func test_init_notLoadData() {
        let client = makeSUT().client
        
        XCTAssertNil(client.requestUrl)
    }
    
    func test_load_requestDataFromUrl() {
        let sut = makeSUT().sut
        let client = makeSUT().client
        
        // act
        sut.load()
        
        //Assert
        XCTAssertNotNil(client.requestUrl)
    }
    
    private func makeSUT(url: URL? = URL(string: "www.aaa.com")) -> (sut: RemoteFeedLoader, client: HttpClientSpy) {
        
        // arrang
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
                
        return (sut, client)
    }
    
}
