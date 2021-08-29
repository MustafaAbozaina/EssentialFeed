//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by mustafa salah eldin on 8/22/21.
//

import XCTest
import EssentialFeed

class EssentialFeedTests: XCTestCase {
    let testUrl = URL(string: "www.aaa.com")
    
    // testing that creation of the object not loading any data
    func test_init_notLoadData() {
        let (_, client) = makeSUT(url: testUrl)
        
        XCTAssertNil(client.requestsUrls.first)
    }
    
    func test_load_requestDataFromUrl() {
        let (sut, client) = makeSUT(url: testUrl)
        // act
        sut.load()
        //Assert
        XCTAssertNotNil(client.requestsUrls.first)
    }
    
    func test_loadTwice_requestDataFromUrl() {
        let (sut, client) = makeSUT(url: testUrl)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestsUrls, [testUrl, testUrl])
    }
    
    func test_load_deliversError() {
        let (sut, client) = makeSUT(url: testUrl)
        
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
        // arrang
        let (sut, client) = makeSUT(url: testUrl)
        
        // act
        let codeStatusSamples = [199, 201, 300, 400, 401, 500]
        codeStatusSamples.enumerated().forEach { index, statusCode in
            var capturedErrors =  [RemoteFeedLoader.Error]()
            sut.load() { error in
                capturedErrors.append(error)
            }
            client.complete(withStatusCode: statusCode, at: index)
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
    
    func test_load_deliversErrorOn200HttpResponseBecauseInvalidJson() {
        let (sut, client) = makeSUT(url: testUrl)
        
        var capturedErros = [RemoteFeedLoader.Error]()
        sut.load() { error in
            capturedErros.append(error)
        }
        let invalidJSON = Data(bytes: "invliad json".utf8)
//        client.complete(withStatusCode: 200, data: invalidJSON)
        
        
    }
    
    //MARK:- HELPERS
    
    private func makeSUT(url: URL? = URL(string:"www.aaa.com" )) -> (sut: RemoteFeedLoader, client: HttpClientSpy) {
        // arrang
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    class HttpClientSpy: HttpClient {
        private var messages = [(url: URL, completion: (HttpClientResult) -> Void)]()
        
        var requestsUrls: [URL] {
            return messages.map {$0.url}
        }
        
        func get(from url: URL?, completion: @escaping (HttpClientResult) -> Void) {
            if let url = url {
                messages.append((url,completion))
            }
        }
        
        func complete(with error: Error, at index:Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            if code != 200 {
                
                let response = HTTPURLResponse(url: requestsUrls[index], statusCode: code, httpVersion: nil, headerFields: nil)
                if let response = response {
                    messages[index].completion(.success(response))
                }
            }
        }
    }
}
