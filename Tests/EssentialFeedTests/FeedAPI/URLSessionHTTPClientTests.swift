//
//  File.swift
//  
//
//  Created by Victor Pacheco on 24/12/20.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
     func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTSessionDataTask
}

protocol HTTSessionDataTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://anu-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://anu-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "any error", code: 1)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTSessionDataTask
            let error: Error?
        }
        
        init() {}
        
        func stub(url: URL, task: HTTSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTSessionDataTask {
            guard let stub = stubs[url] else { fatalError("Couldn't fins stub for \(url)")}
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTSessionDataTask {
        init() {}
        
        func resume() { }
    }
    
    private class URLSessionDataTaskSpy: HTTSessionDataTask {
        var resumeCallCount = 0
        
        init() {}
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
