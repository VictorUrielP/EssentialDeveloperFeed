//
//  File.swift
//  
//
//  Created by Victor Pacheco on 23/12/20.
//

import XCTest

class RemoteFeedLoader {
 
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://www.aurl.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    var requestedURL: URL?
    
    private init() {}
}

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
