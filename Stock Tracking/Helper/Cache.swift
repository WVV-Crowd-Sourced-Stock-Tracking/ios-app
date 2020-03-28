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
    
    static func load<T: Codable>(for key: String, of type: T.Type) -> AnyPublisher<T, Never> {
        do {
            let url = Cache.url(for: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder.standard.decode(T.self, from: data)
            return Just(object)
                .eraseToAnyPublisher()
        } catch {
            return Empty()
                .eraseToAnyPublisher()
        }
    }
    
    static func save<T: Codable>(_ object: T, for key: String) {
        let url = Cache.url(for: key)
        if let data = try? JSONEncoder.standard.encode(object) {
            try? data.write(to: url)
        }
    }
}

extension Publisher where Output: Codable {
    func cache(for key: String) -> AnyPublisher<Output, Failure> {
        self.handleEvents(receiveOutput: { Cache.save($0, for: key) })
            .merge(with: Cache.load(for: key, of: Output.self).setFailureType(to: Failure.self))
            .eraseToAnyPublisher()
    }
}
