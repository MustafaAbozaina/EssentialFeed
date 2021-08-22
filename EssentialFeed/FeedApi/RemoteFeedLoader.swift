//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by mustafa salah eldin on 8/23/21.
//

import Foundation

protocol FeedLoader {
    
}

class RemoteFeedLoader: FeedLoader {
    var client: HttpClient?
    var url: URL?
    
    init(url: URL?, client: HttpClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client?.get(from: url)
    }
}

// <HttpClient> does not need to be a class. it's just a contract defining which external functionality the RemoteFeedLoader needs, so the protocol is a more suitable way for defining it
/// by creating a clean separation with a protocol, we made RemoteFeedLoader open for extension and more flexible
/// first phase of httpclient was a singleton, but it's really uneeded to make singleton to pass a url
protocol HttpClient {
    func get(from url: URL?)
}


class HttpClientSpy: HttpClient {
    var requestUrl: URL?
    
    func get(from url: URL?) {
        requestUrl = url
    }
}
