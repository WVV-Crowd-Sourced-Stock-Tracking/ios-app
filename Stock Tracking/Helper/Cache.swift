//
//  Cache.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 28.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import Foundation
import Combine

struct Cache {
    
    private static func url(for key: String) -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        .appendingPathComponent(key)
        .appendingPathExtension("cache")
        
    }
    
    static func load(for key: String) -> AnyPublisher<Data, Never> {
        do {
            let url = Cache.url(for: key)
            let data = try Data(contentsOf: url)
            return Just(data)
                .eraseToAnyPublisher()
        } catch {
            return Empty()
                .eraseToAnyPublisher()
        }
    }
    
    static func save(_ data: Data, for key: String) {
        let url = Cache.url(for: key)
        try? data.write(to: url)
    }
}

extension Publisher where Output == Data {
    func cache(for key: String) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveOutput: { Cache.save($0, for: key) })
            .merge(with: Cache.load(for: key).setFailureType(to: Failure.self))
            .eraseToAnyPublisher()
    }
}
