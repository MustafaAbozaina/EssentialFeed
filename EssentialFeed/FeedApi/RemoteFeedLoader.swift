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
    
    // here's Error type, the compiler will understand that The very near class to it which is Error extends Swift.Error
    public func load(completion:@escaping (Error) -> Void = {_ in}) {
        client?.get(from: url) { error in
            completion(.connectivity)
        }
    }
    // we are using Swift.Error not just (Error), to tell the compiler don't complain because the Error type we are creating differ from Error in Swift so if you wrote Error: Error -->  the compiler will trigger an error so that we used Swift.Error to let it know that
    public enum Error: Swift.Error {
        case connectivity
    }
}

// <HttpClient> does not need to be a class. it's just a contract defining which external functionality the RemoteFeedLoader needs, so the protocol is a more suitable way for defining it
/// by creating a clean separation with a protocol, we made RemoteFeedLoader open for extension and more flexible
/// first phase of httpclient was a singleton, but it's really uneeded to make singleton to pass a url
public protocol HttpClient {
    func get(from url: URL?, completion: @escaping (Error) -> Void)
    var requestsUrls: [URL] {get}
}



