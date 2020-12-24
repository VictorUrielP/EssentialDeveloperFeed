//
//  File.swift
//  
//
//  Created by Victor Pacheco on 23/12/20.
//

import Foundation

public final class RemoteFeedLoader {
    public let client: HTTPClient
    public let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMaper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
