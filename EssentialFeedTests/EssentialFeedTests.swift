//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by mustafa salah eldin on 8/22/21.
//

import XCTest


struct FeedItem {
    let id: Int
    let image: URL
    let location: String?
    let description: String?
}

protocol FeedLoader {
    
}

class RemoteFeedLoader: FeedLoader {
    var client: HttpClient?
    
    init(client: HttpClient) {
        self.client = client
    }
    
    func load() {
        client?.requestUrl = URL(string: "www.aaa.com")
    }
}

protocol HttpClient {
    func get(from url: URL)
    
}

class HttpClientSpy: HttpClient {
    var requestUrl: URL?
    
    func get(from url: URL) {
        requestUrl = url
    }
    
    
}


class EssentialFeedTests: XCTestCase {
    
    // testing that creation of the object not loading any data
    func test_init_notLoadData() {
        let client = 
        let _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestUrl)
    }
    
    func test_load_requestDataFromUrl() {
        //arrang
        let client = HttpClient.shared
        let sut = RemoteFeedLoader(client: client)
        
        // act
        sut.load()
        
        //Assert
        XCTAssertNotNil(client.requestUrl)
    }
    
    
}
