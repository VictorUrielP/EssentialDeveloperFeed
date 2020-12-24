//
//  File.swift
//  
//
//  Created by Victor Pacheco on 23/12/20.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    public let client: HTTPClient
    public let url: URL
 
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
