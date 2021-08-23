//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by mustafa salah eldin on 8/22/21.
//

import XCTest
import EssentialFeed

class EssentialFeedTests: XCTestCase {
    
    // testing that creation of the object not loading any data
    func test_init_notLoadData() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestUrl)
    }
    
    func test_load_requestDataFromUrl() {
        let (sut, client) = makeSUT(url: URL(string: "www.aaa.com"))
        
        // act
        sut.load()
        
        //Assert
        XCTAssertNotNil(client.requestUrl)
    }

    //MARK:- HELPERS
    
    private func makeSUT(url: URL? = URL(string:"www.aaa.com" )) -> (sut: RemoteFeedLoader, client: HttpClientSpy) {
        // arrang
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
                
        return (sut, client)
    }
    
    class HttpClientSpy: HttpClient {
        var requestUrl: URL?
        
        func get(from url: URL?) {
            requestUrl = url
        }
    }
}
