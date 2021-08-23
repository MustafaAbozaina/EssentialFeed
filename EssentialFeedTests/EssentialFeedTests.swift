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
        let url = URL(string: "www.aaa.com")
        let (_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestsUrls.first)
    }
    
    func test_load_requestDataFromUrl() {
        let url = URL(string: "www.aaa.com")
        let (sut, client) = makeSUT(url: url)
        
        // act
        sut.load()
        
        //Assert
        XCTAssertNotNil(client.requestsUrls.first)
    }
    
    func test_loadTwice_requestDataFromUrl() {
        let url = URL(string: "www.aaa.com")
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestsUrls, [url, url])
    }
    
    func test_load_deliversError() {
        let url = URL(string: "www.aaa.com")
        let (sut, client) = makeSUT(url: url)
        
        var capturedErro: RemoteFeedLoader.Error?
        sut.load() {error in capturedErro = error}
        
        XCTAssertEqual(capturedErro, .connectivity)
        
    }
    

    //MARK:- HELPERS
    
    private func makeSUT(url: URL? = URL(string:"www.aaa.com" )) -> (sut: RemoteFeedLoader, client: HttpClientSpy) {
        // arrang
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
                
        return (sut, client)
    }
    
    class HttpClientSpy: HttpClient {
        var error: Error?
        var requestsUrls = [URL]()
        
        func get(from url: URL?, completion: @escaping (Error) -> Void) {
            if let unwrappedUrl = url {
                requestsUrls.append(unwrappedUrl)
            }
            if let error = error {
                completion(error)
            }
        }
    }
}
