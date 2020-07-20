//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}
		
	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}
	
	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                
                guard response.statusCode == 200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                if let _ = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    completion(.success([]))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
                
            case let .failure(error):
                completion(.failure(Error.connectivity))
            }
            
        }
    }
}
