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
        
        var capturedErrors =  [RemoteFeedLoader.Error]()
        // 1- load method should use (get method) from httpClient, which append a completion in the completions completions array
        sut.load() { error in
            // 2- in client class (get method) passed a completion to the array so this completion is saved in completions array and its index is 0
//            error in capturedErrors.append(error)
                capturedErrors.append(error)
        }
        
        // to check that
        let clientError = NSError(domain: "test", code: 12)
        // in client completions array the error saved so to fire the completion which have the code of capturedErros.append($0) we should call the next line
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_devliversErrorOnNon200HttpResponse() {
        let url = URL(string: "www.aaa.com")
        // arrang
        let (sut, client) = makeSUT(url: url)
        var capturedErrors =  [RemoteFeedLoader.Error]()
        sut.load() { error in
                capturedErrors.append(error)
        }
        // act
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    

    //MARK:- HELPERS
    
    private func makeSUT(url: URL? = URL(string:"www.aaa.com" )) -> (sut: RemoteFeedLoader, client: HttpClientSpy) {
        // arrang
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
                
        return (sut, client)
    }
    
    class HttpClientSpy: HttpClient {
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestsUrls: [URL] {
            return messages.map {$0.url}
        }
                
        func get(from url: URL?, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            if let url = url {
                messages.append((url,completion))
            }
        }
        
        func complete(with error: Error, at index:Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            if code != 200 {
                let response = HTTPURLResponse(url: requestsUrls[index], statusCode: code, httpVersion: nil, headerFields: nil)
                messages[index].completion(nil, response)
            }
        }
    }
}
