//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by mustafa salah eldin on 8/23/21.
//

import Foundation

protocol FeedLoader {
    
}

public class RemoteFeedLoader: FeedLoader {
    var client: HttpClient?
    var url: URL?
    
    public init(url: URL?, client: HttpClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client?.get(from: url)
    }
}

// <HttpClient> does not need to be a class. it's just a contract defining which external functionality the RemoteFeedLoader needs, so the protocol is a more suitable way for defining it
/// by creating a clean separation with a protocol, we made RemoteFeedLoader open for extension and more flexible
/// first phase of httpclient was a singleton, but it's really uneeded to make singleton to pass a url
public protocol HttpClient {
    func get(from url: URL?)
}



